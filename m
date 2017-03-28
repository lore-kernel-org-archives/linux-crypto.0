From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 10:28:44 -0500
Message-ID: <17bcfec8-1095-a49e-184f-4b43bad29c98@amd.com>
References: <20170328095814.3734615-1-arnd@arndb.de>
 <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
 <CAK8P3a2T4ZmT+EWqARw0L7X+E-B36_RwmBRD7PM-8YBnSMR0Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, "Hook, Gary" <Gary.Hook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2T4ZmT+EWqARw0L7X+E-B36_RwmBRD7PM-8YBnSMR0Pw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/28/2017 10:10 AM, Arnd Bergmann wrote:
> On Tue, Mar 28, 2017 at 4:15 PM, Gary R Hook <ghook@amd.com> wrote:
>> On 03/28/2017 04:58 AM, Arnd Bergmann wrote:> The newly added AES GCM
>> implementation uses one of the largest stack frames
>
>>> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
>>> index 3a45c2af2fbd..c5ea0796a891 100644
>>> --- a/drivers/crypto/ccp/ccp-dev.h
>>> +++ b/drivers/crypto/ccp/ccp-dev.h
>>> @@ -432,24 +432,24 @@ struct ccp_dma_info {
>>>          unsigned int offset;
>>>          unsigned int length;
>>>          enum dma_data_direction dir;
>>> -};
>>> +} __packed __aligned(4);
>>
>>
>> My gcc 4.8 doesn't understand __aligned(). Shouldn't we use
>> #pragma(4) here?
>
> That is odd, the __aligned() macro gets defined for all compiler versions
> in linux/compiler.h, and the aligned attribute should work for all supported
> compilers (3.2 and higher), while #pragma pack() requires gcc-4.0 or
> higher.
>
> We generally prefer attribute syntax in the kernel over pragmas, even
> when they are functionally the same.

Yes, it's extremely odd, and I understand this preference. Please ignore my
submitted alternate and let me track this down....


-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
