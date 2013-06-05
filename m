From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/4] crypto: dcp: Remove redundant platform_set_drvdata()
Date: Wed, 5 Jun 2013 08:52:03 +0530
Message-ID: <CAK9yfHxDekruYdXRfDOCuwx_TDhh6rFazfKrYTgsK0xEwjvtnA@mail.gmail.com>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
	<51AE3E24.6000907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Tobias Rauter <tobiasrauter@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:48648 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FEDWF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jun 2013 23:22:05 -0400
Received: by mail-ob0-f182.google.com with SMTP id va7so1745173obc.41
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jun 2013 20:22:03 -0700 (PDT)
In-Reply-To: <51AE3E24.6000907@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tobias,

On 5 June 2013 00:51, Tobias Rauter <tobiasrauter@gmail.com> wrote:
> On 29.05.2013 13:39, Sachin Kamat wrote:
>>
>> Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
>> driver is bound) removes the need to set driver data field to
>> NULL.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Tobias Rauter <tobias.rauter@gmail.com>
>> ---
>> This series compile tested against linux-next (20130529).
>
>
> Hi!
>
> Thank you for the corrections.
>
> I tested this series on Freescale's evalboard with v3.10-rc4.

Thanks for testing. Perhaps Herbert could add you to "Tested-by:"
while applying this series?


-- 
With warm regards,
Sachin
