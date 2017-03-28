From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 17:10:08 +0200
Message-ID: <CAK8P3a2T4ZmT+EWqARw0L7X+E-B36_RwmBRD7PM-8YBnSMR0Pw@mail.gmail.com>
References: <20170328095814.3734615-1-arnd@arndb.de> <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 28, 2017 at 4:15 PM, Gary R Hook <ghook@amd.com> wrote:
> On 03/28/2017 04:58 AM, Arnd Bergmann wrote:> The newly added AES GCM
> implementation uses one of the largest stack frames

>> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
>> index 3a45c2af2fbd..c5ea0796a891 100644
>> --- a/drivers/crypto/ccp/ccp-dev.h
>> +++ b/drivers/crypto/ccp/ccp-dev.h
>> @@ -432,24 +432,24 @@ struct ccp_dma_info {
>>          unsigned int offset;
>>          unsigned int length;
>>          enum dma_data_direction dir;
>> -};
>> +} __packed __aligned(4);
>
>
> My gcc 4.8 doesn't understand __aligned(). Shouldn't we use
> #pragma(4) here?

That is odd, the __aligned() macro gets defined for all compiler versions
in linux/compiler.h, and the aligned attribute should work for all supported
compilers (3.2 and higher), while #pragma pack() requires gcc-4.0 or
higher.

We generally prefer attribute syntax in the kernel over pragmas, even
when they are functionally the same.

      Arnd
