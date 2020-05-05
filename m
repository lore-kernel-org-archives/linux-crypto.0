Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DD8C47257
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627C920675
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588688369;
	bh=cANn+yfynoapB4bx15gNl+Teq2Q4AoGfjt3dkMML+YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dz2y+wPsR5Y4AVvkGKH1pneuaXruexqxpnVibzrBbGt4npWguvKIEFqlMqVz31CLG
	 UqYtWfdXCimzb2kyIVyFkGBSTONoitbPhscigMzqZfe/yG/B94LZGwaopYbMIPgkhX
	 z3l0wxOq9EZMCJ22x63V8IECMUfTN9GabfVYYEBE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgEEOT2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 10:19:28 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45028 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbgEEOTN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 10:19:13 -0400
Received: by mail-ed1-f66.google.com with SMTP id r7so1899707edo.11
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2020 07:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tH8Jy39F3Mdtkz9Csx4sb5utsxMmdHj9M8JrCE26sBc=;
        b=IneCuK60nCuTY6gfGXHdCRTKRCM37KPJKT0KLF3tFkRLIdgr+b5GNKTttkm7pOV0RS
         SGBTcSg5zC0CZmBy/f/hOZPjKxRtOLAlXXcRbQXymUEcNvuw8sJe+DnrWZIZAySdu3c0
         yNHmIX4dioG9dQr/g0DJoSSc/8n4q6lJmN4pHkmx/vTcMtVeUQ8GLdATYHc6dzeDU4mU
         D0fOD3GSuSfp1QXA0GReka/UDb3FDyOCxpH5czrM9QsfbceTK9KKgXf0fap0CE1FFBVB
         bjVzqPzUcz7pBPNHOPlp0j3mg8llNTDK7cwzRqlbZusMRJJ5c4AcHMc8UR6HUeHBBpXe
         iZ8Q==
X-Gm-Message-State: AGi0PuYptDBOUHAA2ob/+SFHIpxDZj+okBo9P/T/0FphshtvTodzozqo
        dzkWf69AbvCtnSiDkNLfpj8=
X-Google-Smtp-Source: APiQypJ2CNSRzy1yuJBTVg6cPPmCKdViExCblrx20dO9wvPntaLlDO/JzKht2tWlolO1DBPBgfSlpw==
X-Received: by 2002:aa7:de0b:: with SMTP id h11mr2871264edv.133.1588688351173;
        Tue, 05 May 2020 07:19:11 -0700 (PDT)
Received: from kozik-lap ([194.230.155.237])
        by smtp.googlemail.com with ESMTPSA id a5sm30748edn.14.2020.05.05.07.19.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 May 2020 07:19:10 -0700 (PDT)
Date:   Tue, 5 May 2020 16:19:08 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@samsung.com>
Subject: Re: [PATCH 11/20] crypto: s5p-sss - use crypto_shash_tfm_digest()
Message-ID: <20200505141908.GA2874@kozik-lap>
References: <20200502053122.995648-1-ebiggers@kernel.org>
 <20200502053122.995648-12-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200502053122.995648-12-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 01, 2020 at 10:31:13PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of manually allocating a 'struct shash_desc' on the stack and
> calling crypto_shash_digest(), switch to using the new helper function
> crypto_shash_tfm_digest() which does this for us.
> 
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Cc: Kamil Konieczny <k.konieczny@samsung.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/s5p-sss.c | 39 ++++++---------------------------------
>  1 file changed, 6 insertions(+), 33 deletions(-)

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

