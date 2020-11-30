Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD566C71155
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 02:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B3520857
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 02:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlbMP+VJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgK3Ck6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgK3Ck6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Nov 2020 21:40:58 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B5120796;
        Mon, 30 Nov 2020 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606704017;
        bh=+o51HGYQAabd+bBncNaq+T1AM3nmV45eMx6YXRss1JY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlbMP+VJ63i/dSwtGdVeNtERCGzCpf+dvLQAuOAjyYYl2ZgVSnK9fYpCYNDFuQqdf
         fV1WbcQezdfNCw8TpdcoBgwSCYTy3FxKMIPdlLqHgGERYZytx2uBxkdQpgctF5I4LK
         E9z7Lv4sbGtfGQNk6bSz/zgna30/ocRhNkdcFp7Y=
Date:   Mon, 30 Nov 2020 04:40:11 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v1 0/9] Enable root to update the blacklist keyring
Message-ID: <20201130024011.GA24870@kernel.org>
References: <20201120180426.922572-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120180426.922572-1-mic@digikod.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 20, 2020 at 07:04:17PM +0100, Mickaël Salaün wrote:
> Hi,
> 
> This patch series mainly add a new configuration option to enable the
> root user to load signed keys in the blacklist keyring.  This keyring is
> useful to "untrust" certificates or files.  Enabling to safely update
> this keyring without recompiling the kernel makes it more usable.

I apologize for latency. This cycle has been difficult because of
final cuts with the huge SGX patch set.

I did skim through this and did not see anything striking (but it
was a quick look).

What would be easiest way to smoke test the changes?

> Regards,
> 
> Mickaël Salaün (9):
>   certs: Fix blacklisted hexadecimal hash string check
>   certs: Make blacklist_vet_description() more strict
>   certs: Factor out the blacklist hash creation
>   certs: Check that builtin blacklist hashes are valid
>   PKCS#7: Fix missing include
>   certs: Fix blacklist flag type confusion
>   certs: Allow root user to append signed hashes to the blacklist
>     keyring
>   certs: Replace K{U,G}IDT_INIT() with GLOBAL_ROOT_{U,G}ID
>   tools/certs: Add print-cert-tbs-hash.sh
> 
>  MAINTAINERS                                   |   2 +
>  certs/.gitignore                              |   1 +
>  certs/Kconfig                                 |  10 +
>  certs/Makefile                                |  15 +-
>  certs/blacklist.c                             | 210 +++++++++++++-----
>  certs/system_keyring.c                        |   5 +-
>  crypto/asymmetric_keys/x509_public_key.c      |   3 +-
>  include/keys/system_keyring.h                 |  14 +-
>  include/linux/verification.h                  |   2 +
>  scripts/check-blacklist-hashes.awk            |  37 +++
>  .../platform_certs/keyring_handler.c          |  26 +--
>  tools/certs/print-cert-tbs-hash.sh            |  91 ++++++++
>  12 files changed, 335 insertions(+), 81 deletions(-)
>  create mode 100755 scripts/check-blacklist-hashes.awk
>  create mode 100755 tools/certs/print-cert-tbs-hash.sh
> 
> 
> base-commit: 09162bc32c880a791c6c0668ce0745cf7958f576
> -- 
> 2.29.2
> 
> 

/Jarkko
