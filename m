From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 8/8 v4] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Thu, 23 Jan 2014 11:41:27 +0100
Message-ID: <52E0F1D7.4030401@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
 <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
 <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	herbert@gondor.apana.org.au, cpgs@samsung.com,
	tomasz.figa@gmail.com
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
	Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 23/01/14 11:18, Naveen Krishna Ch wrote:
> Hello All,
> 
> On 15 January 2014 14:47, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> This patch set adds use of clk_prepare/clk_unprepare as
>> required by generic clock framework.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>> Changes since v3:
>> None
>>
>>  drivers/crypto/s5p-sss.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index f7c66c7..870e794 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -648,7 +648,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>                 return -ENOENT;
>>         }
>>
>> -       clk_enable(pdata->clk);
>> +       clk_prepare_enable(pdata->clk);

How about properly checking the return value ?

--
Thanks,
Sylwester
