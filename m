Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D354C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72440206E0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561698861;
	bh=DhELx/49gV/5AuHJO3qXMkk+Qyz7QJ3lUm8zTqvLcYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QGs6sG/PIPw2orIn849Pcyvyjap1aPpj5HWiYOBzCKVqoNMaYptfqQmSPX8xAfHqX
	 jMYE6G7M20k0tfbnd5ThmzKnkAlxSzg8hL39QNP6DPOBxfy1SNtx9XACan7abYNEYj
	 i9g2wOkE6eDIc2kFiA/3+53ogJ9vTo00+iwY2yRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfF1FOR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfF1FOR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:14:17 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C988C206E0;
        Fri, 28 Jun 2019 05:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561698856;
        bh=DhELx/49gV/5AuHJO3qXMkk+Qyz7QJ3lUm8zTqvLcYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=quxPhB6DFbqKCfyAC8+TBO1u90nmYR+3Pv+Kq2NZ+nT5ZtaFJQiQzhymfHzYN7Fcr
         +08B/y4VUwyws6NcZO/49T2i1tQ3Y9EyyrnvwPyNROL1SUVcHL6QKu5LrBNyNEsXqj
         rHKtZAZVllT4ZxBR7WA/Ud88xpfD79ZMDu6qwjEg=
Date:   Thu, 27 Jun 2019 22:14:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        t-kristo@ti.com, linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 07/10] crypto: sa2ul: Add hmac(sha1) HMAC
 algorithm support
Message-ID: <20190628051412.GG673@sol.localdomain>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-8-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628042745.28455-8-j-keerthy@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 09:57:42AM +0530, Keerthy wrote:
> +static int sa_sham_update(struct ahash_request *req)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int sa_sham_final(struct ahash_request *req)
> +{
> +	return sa_sham_digest(req);
> +}
> +
> +static int sa_sham_finup(struct ahash_request *req)
> +{
> +	return sa_sham_digest(req);
> +}

You can't just not support update().  You need to support update().

- Eric
