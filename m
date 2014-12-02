From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 07/17] crypto: ansi_cprng - Shrink rand_read_pos & flags
Date: 2 Dec 2014 15:28:17 -0500
Message-ID: <20141202202817.15802.qmail@ns.horizon.com>
References: <20141202145911.GF3388@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:52015 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933009AbaLBU2T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 15:28:19 -0500
In-Reply-To: <20141202145911.GF3388@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> --- a/crypto/ansi_cprng.c
>> +++ b/crypto/ansi_cprng.c
>> @@ -51,9 +51,9 @@ struct prng_context {
>>  	unsigned char rand_data[DEFAULT_BLK_SZ];
>>  	unsigned char DT[DEFAULT_BLK_SZ];
>>  	unsigned char V[DEFAULT_BLK_SZ];
>> -	u32 rand_read_pos;	/* Offset into rand_data[] */
>> +	unsigned char rand_read_pos;	/* Offset into rand_data[] */

> u8 please.  Also, not sure if this helps much, as I think the padding
> will just get you back to word alignment on each of these.

I noticed the "unsigned char" vs "u8" issue, but didn't make the change
as I didn't think the readailility improvement was worth the code churn.

But I'd be happy to clean that up, too!

Should I convert all the buffers and function prototypes, or is there
some criterion for distinguishing which gets which?   (E.g. buffers are
"unsigned char" but control variables are "u8".)

And actually, you do win.  spinlock_t is 16 bits on x86,
and the buffers are all 16 bytes.   (80 bytes before my earlier
patches, 48 bytes after.)

So the the structure goes from:

32-bit		64-bit		Variable
Offset	Size	Offset	Size
 0	2	 0	2	spinlock_t prng_lock
 2	16	 2	16	unsigned char rand_data[16]
18	16	18	16	unsigned char DT[16]
34	16	34	16	unsigned char V[16]
50	2	50	2	(alignemnt)
52	4	52	4	u32 rand_read_pos
56	4	56	8	struct crypto_cipher *tfm
60	4	64	4	u32 flags
		68	4	(alignment)
64		72		(structure size)

to

32-bit		64-bit		Variable
Offset	Size	Offset	Size
34	16	34	16	unsigned char V[16]
50	1	50	1	u8 rand_read_pos
51	1	51	1	u8 flags
		52	4	(alignment)
52	4	56	8	struct crypto_cipher *tfm
56		64		(structure size)

You still get 4 bytes of alignment padding on x86-64, but given that
the structure has 60 bytes of payload, that's the minimum possible.

You save 6 bytes of variables and 2 bytes of padding on both
32- and 64-bit systems, for a total of 8 bytes, and that's enough
to knock you into a smaller slab object bin on 64-bit.


I forget where I read the terminology, but the most efficient
wat to pack a structure is in an "organ pipe" configuraiton where
the biggest (in terms of *alignment*) members are on the outside
and the structre and the smaller elements are on the inside.
Putting a 32-bit "flags" after a 64-bit pointer violates that.
