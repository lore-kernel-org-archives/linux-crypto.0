Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E75C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 04:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FCF238E2
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 04:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhANEQL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 23:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbhANEQK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 23:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9062221EA;
        Thu, 14 Jan 2021 04:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610597730;
        bh=5bNu9OxM9PUIxaOuedQwfOFYLhmDVNIPEZSAT3dGhb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lrSQCF9v7s7KHxfHt1nkxgsmvAit5IxBibLwjFe2veJ3/4mOHUNU1Z4GkBW3HKTfX
         V5Vcy5OHNrVjf3NxqbB/STou7PmQ+6bK0zTLYvQieLffpEzIXdlAa3eMGytH4gxVoh
         f/3+LsE4zIaW9espS0TlkNyF4vihVTAUORBcgS40TZDk2U/Pt3+4GV36s4mJ90qp6x
         BmUWhC9474MZLGcxHWUG6uwhLPx/ECjuQ92VnC7nPZNhD+kXzamEL5TQbmzgUbDN2d
         L0gmAdcGs8DocVDSD68w0WVDWbF+KNM4Gf1+s2XbynEQo9SR3QnfURob5hY+q2kRm8
         H2ENi2WpF+SZg==
Date:   Thu, 14 Jan 2021 06:15:24 +0200
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
Subject: Re: [PATCH v2 0/5] Enable root to update the blacklist keyring
Message-ID: <X//FXJjQNV/ElHQg@kernel.org>
References: <20201211190330.2586116-1-mic@digikod.net>
 <67945fa6-2796-bfcd-5541-d54662e9802a@digikod.net>
 <X/qJJsVe7+nP+gR6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/qJJsVe7+nP+gR6@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jan 10, 2021 at 06:57:10AM +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 05, 2021 at 11:12:57AM +0100, Mickaël Salaün wrote:
> > Jarkko, David, what is the status of this patch series? Do you need help
> > to test it?
> 
> Hi, a leave/vacation and the holiday period badly mixed my schedules.
> 
> I'm testing this upcoming week.
> 
> /Jarkko

❯ git-pw series apply 400795
Applying: certs: Make blacklist_vet_description() more strict
error: sha1 information is lacking or useless (certs/blacklist.c).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 certs: Make blacklist_vet_description() more strict
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Can you rebase to rc3 and resend? 

Also, please add this to the patches 1-3:

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

Also, 4-5 look good but I hold for testing before acking further.

Thanks, and apologies for such a long wait.

/Jarkko
