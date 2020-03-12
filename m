Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFF8C10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AAC9206B1
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCLMkO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:40:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60016 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgCLMkO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:40:14 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jCN85-000244-Er; Thu, 12 Mar 2020 23:40:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Mar 2020 23:40:01 +1100
Date:   Thu, 12 Mar 2020 23:40:01 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Connor Kuehl <ckuehl@redhat.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, gary.hook@amd.com,
        erdemaktas@google.com, rientjes@google.com, brijesh.singh@amd.com,
        npmccallum@redhat.com, bsd@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl permissions
Message-ID: <20200312124001.GG28885@gondor.apana.org.au>
References: <20200306172010.1213899-1-ckuehl@redhat.com>
 <20200306172010.1213899-2-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306172010.1213899-2-ckuehl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 06, 2020 at 09:20:10AM -0800, Connor Kuehl wrote:
> Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> check the file mode for write permissions before executing commands that
> can affect the platform. This allows for more fine-grained access
> control to the SEV ioctl interface. This would allow a SEV-only user
> or group the ability to administer the platform without requiring them
> to be root or granting them overly powerful permissions.
> 
> For example:
> 
> chown root:root /dev/sev
> chmod 600 /dev/sev
> setfacl -m g:sev:r /dev/sev
> setfacl -m g:sev-admin:rw /dev/sev
> 
> In this instance, members of the "sev-admin" group have the ability to
> perform all ioctl calls (including the ones that modify platform state).
> Members of the "sev" group only have access to the ioctls that do not
> modify the platform state.
> 
> This also makes opening "/dev/sev" more consistent with how file
> descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> the file descriptor could be opened read-only but could still execute
> ioctls that modify the platform state. This patch enforces that the file
> descriptor is opened with write privileges if it is going to be used to
> modify the platform state.
> 
> This flexibility is completely opt-in, and if it is not desirable by
> the administrator then they do not need to give anyone else access to
> /dev/sev.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
