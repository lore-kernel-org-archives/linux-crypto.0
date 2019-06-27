Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0CEC48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92DD62146E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561653648;
	bh=nNVG+IDzbIeEVq65elRdqny10jN+YiugKfrEYScPmbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PZulbsRrN0Oy1chCHsgI6/4Adn+brrMuc3WrTVqwKI4pTs+WzAAg5bB2nEuyaaTwv
	 v83jwD503I/TYF96MoOO9+Bji1xpZCelm2TQhDEfguIltZVxvYwT3k+EnLV22+AsKr
	 kBPVqVNY3WdJPixYy7zc9MW3pvSQE0hvlrFLNj/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfF0Qks (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfF0Qks (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 12:40:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA42208E3;
        Thu, 27 Jun 2019 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561653647;
        bh=nNVG+IDzbIeEVq65elRdqny10jN+YiugKfrEYScPmbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkP9iRzla7wMEKlyWi2QYrAjIKvPg/6kpeDLXNvdvMxFCo8b272C5ZX5KlfYar2Av
         vllgmGG/Bh1qu/jloayliKN8fU2IgkKVj6sIow+Fh/cnwZkbkX/GvwFwDjl7+a3nBt
         UF+kV2Wlo6WEhFL6O8oZF3F6/M7wJlOBv3jcT7aw=
Date:   Thu, 27 Jun 2019 09:40:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v5 7/7] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
Message-ID: <20190627164045.GE686@sol.localdomain>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
 <20190626204047.32131-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204047.32131-8-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 26, 2019 at 10:40:47PM +0200, Ard Biesheuvel wrote:
> Add an accelerated version of the 'essiv(cbc(aes),aes,sha256'
> skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> This avoids a separate call into the AES cipher for every invocation.

This technically should say "in some cases by fscrypt and dm-crypt", since as
we've discussed previously, most of the time this is not what fscrypt uses.

- Eric
