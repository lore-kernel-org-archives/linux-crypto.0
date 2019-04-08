Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25148C282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F23DD2084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfDHGk1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:40:27 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45824 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfDHGk1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:40:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNxB-00087c-5C; Mon, 08 Apr 2019 14:40:25 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNx9-0005pH-Or; Mon, 08 Apr 2019 14:40:23 +0800
Date:   Mon, 8 Apr 2019 14:40:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Subject: Re: [PATCH v2] crypto: ccp: introduce SEV_GET_ID2 command
Message-ID: <20190408064023.e7eteoc6n4bi5qxi@gondor.apana.org.au>
References: <20190328215838.23082-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328215838.23082-1-brijesh.singh@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 28, 2019 at 09:58:52PM +0000, Singh, Brijesh wrote:
> The current definition and implementation of the SEV_GET_ID command
> does not provide the length of the unique ID returned by the firmware.
> As per the firmware specification, the firmware may return an ID
> length that is not restricted to 64 bytes as assumed by the SEV_GET_ID
> command.
> 
> Introduce the SEV_GET_ID2 command to overcome with the SEV_GET_ID
> limitations. Deprecate the SEV_GET_ID in the favor of SEV_GET_ID2.
> 
> At the same time update SEV API web link.
> 
> Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> Change since v1:
>   - Keep the SEV_GET_ID implement and log the deprecated message
> 
>  drivers/crypto/ccp/psp-dev.c | 67 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  3 +-
>  include/uapi/linux/psp-sev.h | 18 +++++++---
>  3 files changed, 82 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
