Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB90C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Nov 2021 23:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhK2XQo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:16:44 -0500
Received: from mail-oo1-f50.google.com ([209.85.161.50]:35514 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhK2XQZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Nov 2021 18:16:25 -0500
Received: by mail-oo1-f50.google.com with SMTP id e17-20020a4a8291000000b002c5ee0645e7so6158745oog.2;
        Mon, 29 Nov 2021 15:13:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TBDeg2T2HpF/0tP7YSfqKZCkBkx3aRwdW2nUjrKDvg=;
        b=PIAX14yOxmA9Q9j37utr168R02jdBfN9Hx91VoAInEpzdg2dao7q978ZBU86F+5hJk
         6dqVUcBo+THqaDPRElBmPz4r9r8noNZPAGhG8uAw0wbTHlDXMTdlQrz/3RjTj4DAZMJ+
         f1tc+4uW2uD4EtpMU0CSlkEQVN9it3I5ChtfuNFDv0E+3ChVCLdRfVNX7sm/+pBndFbE
         aXQv2ZhKo8sbHMWn0lxRa+5Xlh3K+ZsY7HyRGIBf5kdHvyVnWwSfs1lgSlCeYg0OP/bj
         D5YuyQwcvvQHYov75fAXscSgoz4qTBrIJmU9iqdkiR6ad5ocrn9PMXzUJXLGyCHGAtak
         JrYA==
X-Gm-Message-State: AOAM530iVuEc8D7uT8qgTguJsUm3jBC+k/kXydTH289u5SquvRJJXHO/
        BT55qV7LYS/Qbj5x3tmjUvnpJJSnfA==
X-Google-Smtp-Source: ABdhPJwyRuiVmmJZmpoOnClCvsvidYVMOdIq281b10vxbTOqfPqs0KeSY+luLvimvVIvdrBtL7D5ag==
X-Received: by 2002:a4a:6852:: with SMTP id a18mr33373429oof.92.1638227587108;
        Mon, 29 Nov 2021 15:13:07 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j10sm2467950ooq.5.2021.11.29.15.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:13:06 -0800 (PST)
Received: (nullmailer pid 788867 invoked by uid 1000);
        Mon, 29 Nov 2021 23:13:05 -0000
Date:   Mon, 29 Nov 2021 17:13:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        linux-sunxi@lists.linux.dev, Chen-Yu Tsai <wens@csie.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: sun8i-ce: Add compatible for D1
Message-ID: <YaVegSGB+7W7Ulsc@robh.at.kernel.org>
References: <20211119051026.13049-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119051026.13049-1-samuel@sholland.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 18 Nov 2021 23:10:24 -0600, Samuel Holland wrote:
> D1 has a crypto engine similar to the one in other Allwinner SoCs.
> Like H6, it has a separate MBUS clock gate.
> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
> 
>  .../devicetree/bindings/crypto/allwinner,sun8i-ce.yaml      | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
