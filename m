Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564D1C3F2C6
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D25020842
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHga60VN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgCCMfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 07:35:55 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40849 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbgCCMfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 07:35:55 -0500
Received: by mail-wm1-f41.google.com with SMTP id e26so2653940wme.5;
        Tue, 03 Mar 2020 04:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rz2M9V+ocKeCKBO1DTovHWBHdLHnzUuWHLb/2ndomPg=;
        b=GHga60VNe5FeroqHZ/v9n4E2vp3rgvzrlblLNbqORO7SNQfyDjLW5AON9gM6Uwb6xQ
         NuH/FL2Z7dX+BUNOj+YEiLciP9jJgIftKg/HXqpl1XainX2ArMEwtLj+EimmO0+IEUiv
         hhqudlhUeULciWh1yPbxzzyAhuFz4if+ORNrQIbSUOo503U5vshuNOiOf2byKeefwgoH
         oNp3wtIuF18eqbb4I51cXPZoPk6KmLKzwYAu0DuDR9lw4L9zQHm2L1CsgUGinhEIaXJ2
         WCl3PuFlmwE8n0h5hym+lNEOR9OhS6f7rEVjMGcXFDAzGqmq2xBKNYXWbLJfhVWyYTP0
         vpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rz2M9V+ocKeCKBO1DTovHWBHdLHnzUuWHLb/2ndomPg=;
        b=VZ4mlvVbGmrXyBUPW26a4RijXHEb3mGS0EvxbopNnbZdDLcReWhtlyeh2WE1crm669
         Xc1sjOKuBCPLsCPifR6cjctmzP/PD4++yD/yqbj0QdrRqKJDx+u7tyC0pCs77JhVH3+7
         q/0NQNSLZuBB2VB8g7ojlTTgul2ucaXtIxInW2TsH0Dx/cGDkQ4BqynqtbYlYndOYeNJ
         7iAQLrbwp1A2lzlexkPbp6CPu9qmMTD4ygZRGB1sQ8vsUZEL0XlyN5Rwumw6VF2/ujMP
         3J/Hn0pW6iDrN1wby7C0p+TPunkDV0/7t8W435HG4ilY9A/Zc3ZgnBzTeooO9smSovA/
         Lnbw==
X-Gm-Message-State: ANhLgQ2lGA9Olt1KoGWzsdGffIs8yNYKsW/qwcVxbypUEqw8GdkdqnlP
        87zjiHMOm3XH5jfb/Nt1iWGmF37d
X-Google-Smtp-Source: ADFU+vufeWSmB8RAOO4F2s3ATVOHiD1EGO8AhsT03Q02Af0id3T2mAwbnruorwSjWm0o//ef43PtVg==
X-Received: by 2002:a7b:c204:: with SMTP id x4mr4179246wmi.20.1583238952930;
        Tue, 03 Mar 2020 04:35:52 -0800 (PST)
Received: from [10.34.28.108] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k126sm3401852wme.4.2020.03.03.04.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 04:35:52 -0800 (PST)
Subject: Re: [RFC] crypto: xts - limit accepted key length
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        Andrei Botila <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b8c0cbbf0cb94e389bae5ae3da77596d@DM6PR20MB2762.namprd20.prod.outlook.com>
 <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <72e1866a-9202-8d5b-f67b-8d9a63d888a7@gmail.com>
Date:   Tue, 3 Mar 2020 13:35:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CY4PR0401MB3652818432E5A28BC5089E15C3E70@CY4PR0401MB3652.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/03/2020 09:33, Van Leeuwen, Pascal wrote:
> Hmm ... in principle IEEE-1619 also defines XTS *only* for AES. So by that  same
> reasoning, you should also not allow any usage of XTS beyond AES. Yet it is
> actually being actively used(?) with other ciphers in the Linux kernel.
Just FYI - yes, it is actively used with other ciphers.

There is a lot of LUKS devices that use Serpent or Twofish with XTS mode.

The same for TrueCrypt/VeraCrypt, here sometimes it is used also in cipher chain
(both native binaries or cryptsetup code use dm-crypt with crypto API here).

XTS mode is designed for storage encryption only - and at least for disk encryption
I have never seen request for 192bit keys...

Milan
