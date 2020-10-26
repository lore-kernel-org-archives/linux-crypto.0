Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908FFC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F9220874
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 18:30:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYYBJPJx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789790AbgJZSaD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 14:30:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34531 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1789777AbgJZSaD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 14:30:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id k21so6301305wmi.1;
        Mon, 26 Oct 2020 11:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uvxk0V+v5R+Ui18EWs/4gGZzPd6uaBwxyhilQrUITXg=;
        b=DYYBJPJxGMmJNF/y3y79mjSRcAW1v7JjG9JNYaZDgdpZOCygPjbMeRa0vQIfmRZsNn
         xZgToB3m8fKrLviNRf3mJwvPMixZAun3LGDanXoDetiHUeD2OU3jJu19z124C2Lbr86b
         f73wkIEMnIGrCER5eKz7unOkHWK228f2t0MNyEKh96YNQj4cjOLni6LIDLoaiO2jeHL4
         36z6TROaA/c+oddr/xUpHRUslS2Z+vDtyFD0Ayv4wTYHwRNDS73S7E4FyRojYVUY3QHH
         n88EDtjoNPIbL5UdFRViv+bzGPnc0yJvcjFH+fGD9HRujXFzcvQH7plt+iWhFLSaKrG0
         gnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uvxk0V+v5R+Ui18EWs/4gGZzPd6uaBwxyhilQrUITXg=;
        b=iZ3Q0XTW4Jid0ngdshFFIxhhx+1dHT/R22KjLvP6EZPqT/z8fqKetlvfgMI/wllKHt
         9jEW6avsEFj6lsVjM/Ho9fKLxJ0Z3Ne/uwAHPZLsBVAPBgAF/wb5uT9D93lz5dHKoHbI
         0pChcxjxNUSJTXLWo37m9JK97XKXAWrhFNN9FEwflHz5JY0tj1Wo2wxMWP2yCzcDFYsr
         TfhqWbDuriT4I6M2IM2sXo2axfNgjBcQMo4B6NbFK/GcjpvjWLRZOvqyhRfAgT15tWZw
         /EtQLE1JHOAU/nqXClB0qdGxhRzJkHOPSLquj0Haf0h+9wFS0ELoAf/Daz1XaPK8HRYq
         qnLg==
X-Gm-Message-State: AOAM5302kVdEwl8uNhp+lOyU8y6vZrK9VD46dswibkxX3ABFfDd+7GUN
        /Bb8IBFDi3FHcPOfJd8MYyLeIfWLfzA=
X-Google-Smtp-Source: ABdhPJxGuvImDDTPNUyAg2ANEUotzgD+NbaqgYewNtg3QdjYtiYNovB0ZP9faDoV/YdGSo52APdArQ==
X-Received: by 2002:a1c:9c41:: with SMTP id f62mr17094373wme.23.1603737000340;
        Mon, 26 Oct 2020 11:30:00 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id j17sm22999314wrw.68.2020.10.26.11.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 11:29:59 -0700 (PDT)
Subject: Re: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
To:     Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20201026130450.6947-1-gilad@benyossef.com>
 <20201026130450.6947-4-gilad@benyossef.com>
 <20201026175231.GG858@sol.localdomain>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
Date:   Mon, 26 Oct 2020 19:29:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201026175231.GG858@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/10/2020 18:52, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
>> Replace the explicit EBOIV handling in the dm-crypt driver with calls
>> into the crypto API, which now possesses the capability to perform
>> this processing within the crypto subsystem.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>
>> ---
>>  drivers/md/Kconfig    |  1 +
>>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>>  2 files changed, 20 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 30ba3573626c..ca6e56a72281 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -273,6 +273,7 @@ config DM_CRYPT
>>  	select CRYPTO
>>  	select CRYPTO_CBC
>>  	select CRYPTO_ESSIV
>> +	select CRYPTO_EBOIV
>>  	help
>>  	  This device-mapper target allows you to create a device that
>>  	  transparently encrypts the data on it. You'll need to activate
> 
> Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
> Bitlocker compatibility support, they can select this option themselves.

Please no! Until this move of IV to crypto API, we can rely on
support in dm-crypt (if it is not supported, it is just a very old kernel).
(Actually, this was the first thing I checked in this patchset - if it is
unconditionally enabled for compatibility once dmcrypt is selected.)

People already use removable devices with BitLocker.
It was the whole point that it works out-of-the-box without enabling anything.

If you insist on this to be optional, please better keep this IV inside dmcrypt.
(EBOIV has no other use than for disk encryption anyway.)

Or maybe another option would be to introduce option under dm-crypt Kconfig that
defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
selects these IVs/modes.
But requiring some random switch in crypto API will only confuse users.

Milan
