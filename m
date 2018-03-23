From: Vaneet Narang <v.narang@samsung.com>
Subject: Re: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Fri, 23 Mar 2018 18:51:19 +0530
Message-ID: <20180323132119epcms5p8699c2b53a3bab062013e2b3238d0088c@epcms5p8>
References: <20180322042821epcms5p16b4dd6fc12a1563b5aea547f398dda40@epcms5p1>
        <20180321195906.1260480-1-terrelln@fb.com>
        <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
        <CGME20180321195916epcas4p1e89e1cc5fd242ee8c348f92f1d1740b0@epcms5p8>
Reply-To: v.narang@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nick Terrell <terrelln@fb.com>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>
To: Maninder Singh <maninder1.s@samsung.com>,
        Yann Collet <cyan@fb.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322042821epcms5p16b4dd6fc12a1563b5aea547f398dda40@epcms5p1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hi Nick,

Thanks for your comments, Please check my reply to few of your comments.
I will be sharing benchmarking figures separately. 

> 
>> +                        if (curr_offset > 127) {
>> +                                curr_offset = (curr_offset << 1) | DYN_BIT;
>> +                                LZ4_writeLE16(op, (U16)curr_offset);
>> +                                op += 2;
>> +                        } else {
>> +                                curr_offset = curr_offset << 1;
>> +                                *op = (BYTE)curr_offset;
>> +                                op++;
>> +                        }
> 
>The standard way to do variable sized integers is to use the high-bit as
>the control bit, not the low-bit. Do you have benchmarks to show that using
>the low-bit is faster than using the high-bit? If so, lets comment in the
>code, if not lets use the high-bit.
> 
We are not sure about performance difference of using low or high bit but Since as per 
LZ4 specification, offset needs to be stored in little endian format so keeping Low bit 
as control bit makes it easier to retreive offset when offset is spread across two bytes.

offset = LZ4_readLE16(ip);
if (offset & 0x1) {
	offset = offset >> 1; // Just one Right shift
	ip += 2;
} else {
	offset = (offset & 0xff) >> 1; // Only Two Operation for one byte offset
	ip += 1;
}

So not sure if keeping High bit will make much difference as we will be needing 
same or more operations to get offset in case of High bit.

>>                  /* copy literals */
>>                  cpy = op + length;
>>                  if (((endOnInput) && ((cpy > (partialDecoding ? oexit : oend - MFLIMIT))
>> -                        || (ip + length > iend - (2 + 1 + LASTLITERALS))))
>> -                        || ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH))) {
>> +                        || (ip + length > iend - (2 + LASTLITERALS))))
>> +                        || ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH - 1))) {
>>                          if (partialDecoding) {
>>                                  if (cpy > oend) {
>>                                          /*
>> @@ -188,13 +190,31 @@ static FORCE_INLINE int LZ4_decompress_generic(
>>                          break;
>>                  }
>>
>> -                LZ4_wildCopy(op, ip, cpy);
>> +                if (dynOffset && length < 4)
>> +                        LZ4_copy4(op, ip);
>> +                else
>> +                        LZ4_wildCopy(op, ip, cpy);
>> +
> 
>The LZ4 format enforces that the last 5 bytes are literals so that
>LZ4_wildCopy() can be used here. I suspect that having this extra branch
>here for `dynOffset` mode hurts decompression speed.
> 
This check is made to handle one byte read overflow when decompressing last frame. wildCopy does 8 byte copy blindly.

Issue Case:
0 length literal followed by 1 byte offset and then it ends with one byte token and 5 Byte Last Literals.

With this combination only 7 bytes (1 Byte Offset + 1 Byte Token + 5 Byte Literal) remains at the end of 
input buffer so reading 8 bytes from input buffer results in 1 byte overflow.

Since 1 byte offset is not there in original LZ4, so this issue is not possible. To avoid overhead of this check, 
we planned to use 6 Byte as Last literal Length.

-#define LASTLITERALS    5
+#define LASTLITERALS    6

>>
>>  int LZ4_decompress_safe(const char *source, char *dest,
>> -        int compressedSize, int maxDecompressedSize)
>> +        int compressedSize, int maxDecompressedSize, bool dynOffset)
>>  {
>>          return LZ4_decompress_generic(source, dest, compressedSize,
>>                  maxDecompressedSize, endOnInputSize, full, 0,
>> -                noDict, (BYTE *)dest, NULL, 0);
>> +                noDict, (BYTE *)dest, NULL, 0, dynOffset);
> 
>You'll need to use the same trick that LZ4_compress_fast() uses, by hard
>coding `dynOffset`. We want the compiler to generate too version of
>LZ4_decompress_generic(), one with `dynOffset` and one with `!dynOffset`.
>That way the tight loop won't the branches that check `dynOffset`.
> 
>        if (dynOffset)
>                return LZ4_decompress_generic(..., true);
>        else
>                return LZ4_decompress_generic(..., false);
> 
>Without this trick, I expect that this patch causes a regression to both
>LZ4 and LZ4_DYN decompression speed.

Since there is no backward compatibility of our solution with original LZ4 so we
are bit confused if we should make it as separate API to avoid overhead of dynOffset
checks every where in the code and also to avoid changing prototype of exported functions 
LZ4_decompress/LZ4_compress OR we should keep these checks to avoid redundant code. 
Kindly suggest

Thanks & Regards,
Vaneet Narang
