Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F281CC4CECD
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 19:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7745214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568750243;
	bh=DNnw9TY+cVk/mxNQN7BJwyfl4hOHKnPyhZGsBagknLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oUS3jvPrgus500ORIXZnglWlN9MUyTN1J/RD9u3c1ENRHiuZEgde7nLxID+21FpbK
	 NbWw6MHzMhu4Gjn9mGJZoV/7KxfQitupr6e1iHJfTqPW0OLym35sGR4hdKzrsZTJHT
	 BA2Ex3BvudtXYEUaKgHtnz22k4vS2z2kF/vMUkEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfIQT5T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 15:57:19 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44045 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfIQT5T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 15:57:19 -0400
Received: by mail-oi1-f195.google.com with SMTP id w6so3947665oie.11;
        Tue, 17 Sep 2019 12:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8OJcLjUpBrW1/qbYAiu6WuFYEuH8ShVscvI6okWWXn8=;
        b=NBKLjCzBX+ploTfH4gb6j9J2DVp0W13GY+lpEeehz2Eimy8Y7/Xho4G2r1eqvw+ST5
         qhaK7xY/XylrkwXD1f3gwbeHcEq+AjMo3K9HVWWRoO9Pn9pXjCITusMRVT7KrKgaYa/o
         xSXJ34WwiUyi4mk3BFJKjzxc8syedn4g+7wz3xbhDSATjr9RHxf/lIGsNe+ljeQ7iqPj
         3asMHy1PF4Pi9BUpvzDpYdv5+W15mB4/NyGUF0qOIPxFMmMJGCk/sSbk0w6YCqWU8+Jo
         DF+bTOLDF8V5agyl0y4D+9Sg9CIqV267QGZE/fdSKmPGIMVDIqRgEw/HuOusHH5lCAI0
         gdGA==
X-Gm-Message-State: APjAAAWGTSJR4JOOboUl8rZ1F+lPGwQtMkkA1KciEuf1fsXYGZpyh3zM
        UkE4bXfHxmVIP5B3ThYzhw==
X-Google-Smtp-Source: APXvYqyZSU4eFtO2Ik2YQkAoBuTSYow+Kn3ZPm23D3N/+ENyPy94zmiHTTWDOHk5oVigXiOADvOO7w==
X-Received: by 2002:aca:4c84:: with SMTP id z126mr5362414oia.86.1568750238166;
        Tue, 17 Sep 2019 12:57:18 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y137sm1092025oie.53.2019.09.17.12.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 12:57:17 -0700 (PDT)
Date:   Tue, 17 Sep 2019 14:57:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        openbmc@lists.ozlabs.org, Tomer Maimon <tmaimon77@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-binding: hwrng: add NPCM RNG documentation
Message-ID: <20190917195716.GA25687@bogus>
References: <20190912090149.7521-1-tmaimon77@gmail.com>
 <20190912090149.7521-2-tmaimon77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912090149.7521-2-tmaimon77@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 12 Sep 2019 12:01:48 +0300, Tomer Maimon wrote:
> Added device tree binding documentation for Nuvoton BMC
> NPCM Random Number Generator (RNG).
> 
> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> ---
>  .../devicetree/bindings/rng/nuvoton,npcm-rng.txt     | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
