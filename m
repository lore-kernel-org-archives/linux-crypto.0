From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 14/38] crypto: ccp: Implement SEV_FACTORY_RESET
 ioctl command
Date: Mon, 23 Oct 2017 09:42:04 +0200
Message-ID: <20171023074204.GB10952@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-15-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:60668 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbdJWHmE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 03:42:04 -0400
Content-Disposition: inline
In-Reply-To: <20171020023413.122280-15-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 19, 2017 at 09:33:49PM -0500, Brijesh Singh wrote:
> The SEV_FACTORY_RESET command can be used by the platform owner to
> reset the non-volatile SEV related data. The command is defined in
> SEV spec section 5.4
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
