From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH 7/8 v3] crypto:s5p-sss: validate iv before memcpy
Date: Wed, 15 Jan 2014 12:15:16 +0530
Message-ID: <CAHfPSqAtm-Nk1BeC3sWmtUi0dvyfweXSXYnYiQMFzzdWYiDhAg@mail.gmail.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389354321-32096-1-git-send-email-ch.naveen@samsung.com> <52D019BD.30401@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	herbert@gondor.apana.org.au, cpgs@samsung.com,
	tomasz.figa@gmail.com
To: Tomasz Figa <t.figa@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <52D019BD.30401@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Tomasz,

On 10 January 2014 21:33, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
>
> On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
>>
>> This patch adds code to validate "iv" buffer before trying to
>> memcpy the contents
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Changes since v2:
>> None
>>
>>   drivers/crypto/s5p-sss.c |    5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index f274f5f..7058bb6 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -381,8 +381,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>>         struct samsung_aes_variant *var = dev->variant;
>>         void __iomem *keystart;
>>
>> -       memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
>> -                               (var->aes_offset, 0), iv, 0x10);
>> +       if (iv)
>> +               memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
>> +                                       (var->aes_offset, 0), iv, 0x10);
>
>
> In what conditions can the iv end up being NULL?
req->info is the initialization vector in our case, which comes from user space.
Its good to have a check to avoid any crashes.

Also AES ECB mode does not use IV.
>
> Best regards,
> Tomasz



-- 
Shine bright,
(: Nav :)
