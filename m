From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 23 Oct 2017 11:20:20 +0200
Message-ID: <20171023092020.GB19523@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:35662 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbdJWJUc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 05:20:32 -0400
Content-Disposition: inline
In-Reply-To: <20171020023413.122280-14-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 19, 2017 at 09:33:48PM -0500, Brijesh Singh wrote:
> +static int __sev_platform_init(struct sev_data_init *data, int *error)
> +{
> +	int rc = 0;
> +
> +	mutex_lock(&fw_init_mutex);
> +
> +	if (!fw_init_count) {

I still don't like global semaphores. Can you get the status and check
for PSTATE.INIT state and do the init only if the platform is in
PSTATE.UNINIT?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
