Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A779C31E45
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 20:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B02620B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560457007;
	bh=UyOKFdMJpmFac9sY4g4pgaX9ucHa52Pgy3Y1/3XWgwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BlSgkb8mglmks3kp+seQfsJpRdzFKABE1gOoics0R98AKXqBWsy15DOZly/0zymIC
	 C8liw34p8Ecyw7Ht1B3pnZNSpj1WEgAcjqD/C4vqM+mfilfnyu9IUtQHkTP/qHwCwC
	 pwvWsRqVZucIk1j1PJ5bKrvexpM7nAIiicLEffMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfFMUQn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 16:16:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34825 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfFMUQm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 16:16:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id l128so251642qke.2;
        Thu, 13 Jun 2019 13:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o29Lfr65fvnIIWRvGZOgVJ8IvfSfaqLGboe8X2riLtk=;
        b=mIwlx7qoxm9HrPJMnp7PstZ+7vgF7gF6OSMt4M75ZJTJiC7pS+W4ijXq+3FXikeqpM
         cprNoXaXjrUNFxdmu+JXQ/RydzH19vccUs7NSU7RZybNLWiE7N4NsGGTftM1g+8f5pN6
         TM8bQrCth7nTTLUTSkWK98DydjxmJoOxz28SnldU/+kXhLdgtOwpCfjGG/WdEqMHIvPv
         KECRnGJIPBLwcw44Q3TugNeBL1cUziJ4IHGuXu+GmgH/LOnABwqDC21b1uUnjLVFNBQQ
         4/MRyIKY1RAiNAptBcEVHLzmSOugDxFgQDTgAi7WISC0Bvro0F3DDZSq5wvxQagBZFaI
         aJog==
X-Gm-Message-State: APjAAAUe4cgrv1oEnwHBQOWR2TCkuFL9LYcJftHAjRc15zzCt6H1HBZ6
        q8j/bJVKqYpVlw5tHZDIIg==
X-Google-Smtp-Source: APXvYqwuDPeB4Zxm97u7rBXD57/HAa1QJ6DfcEuDcq3KKFpxj60G3NwwBzqtMH4di8Y++XIqdX7MmA==
X-Received: by 2002:a37:4e92:: with SMTP id c140mr72886494qkb.48.1560457001436;
        Thu, 13 Jun 2019 13:16:41 -0700 (PDT)
Received: from localhost ([64.188.179.243])
        by smtp.gmail.com with ESMTPSA id c5sm444341qkb.41.2019.06.13.13.16.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 13:16:40 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:16:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, stefan.wahren@i2se.com,
        wahrenst@gmx.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, mpm@selenic.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] dt-bindings: rng: Document BCM7211 RNG compatible
 string
Message-ID: <20190613201638.GA31578@bogus>
References: <20190510173112.2196-1-f.fainelli@gmail.com>
 <20190510173112.2196-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510173112.2196-2-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 10 May 2019 10:31:10 -0700, Florian Fainelli wrote:
> BCM7211 features a RNG200 block, document its compatible string.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
