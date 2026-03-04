Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980563B8933;
	Wed,  4 Mar 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636370; cv=none; b=UGs2lGsjKqgMNk78pEu+y+HDawNuPcQaS348xe7efo8XuQGxopMZxdDgLVdts8YjTx80fijXtqPWva827JEKZw4/+rgabb/WItkFqqwMDLiPDBqYqQ7TQ82quxfJ5OifdT6CQJklGpyfA2lrxnHrW83E2XfQI0IppHFyzj/0Yn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636370; c=relaxed/simple;
	bh=wdcCO0L/xsiqKhDAxmFbZX2PklbiXgIeuyOJqP0cjh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkmYH8XmOcq1e0yG4rSBNRWT8kNh8yRzKEvCd+MjckgbR2fK5vJJsalKOqdRqwqi7NkGyWqZyJJGVhz95/5qPMup8AynLAC4pFKZIF2b8wCxNTOhqm7aOVpyJ0hJepkJ6zeaRi9hPwX9Pu5EizRpA2USRKc1gu2qDZ6MhgjcHoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcWrCoB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcWrCoB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E660C4CEF7;
	Wed,  4 Mar 2026 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636370;
	bh=wdcCO0L/xsiqKhDAxmFbZX2PklbiXgIeuyOJqP0cjh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcWrCoB9XSvPLBZpVhXmcyBQS/QHLdxxQ7AZ/SOixE7BAcX9w8grlteqNipP/sXsw
	 quN848ax+v+GmwGB79qCW2v02sVZVkarqSIhY8+hndytNw8gqVba27OzRfoFk5zqQA
	 0XFzK7NwKo69EjVa9A/HD57uTxCFArMnAZrmRnIFFM2symIEn/UNJ3BmN++KuRO2lk
	 EA0ggFoXRUXsTa81OGa2Ac2CITb2HmWp34K1hxZB3T0Tw30vA23VfelGruGShCU5d9
	 LjMAnpzm+qzGGt0fOgNC4sIZzP+1aa5nSgrQjN5r1YXZDdxd2U1H2kLJI0PfK62MUc
	 H1Vxb8cte+GOg==
Date: Wed, 4 Mar 2026 07:59:27 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Message-ID: <aahIz8bTPNpnaSZM@tycho.pizza>
References: <20260105172218.39993-1-tycho@kernel.org>
 <0182578a-424d-454f-8a38-57b885eb966b@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0182578a-424d-454f-8a38-57b885eb966b@roeck-us.net>

Hi Guenter,

On Tue, Mar 03, 2026 at 02:35:10PM -0800, Guenter Roeck wrote:
> Hi,
> 
> On Mon, Jan 05, 2026 at 10:22:17AM -0700, Tycho Andersen wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
> > moved from UNINIT to INIT for the function, SNP is not moved back to
> > UNINIT state. Additionally, SNP is not required to be initialized in order
> > to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
> > INIT state and let SNP_PLATFORM_STATUS report the status as is.
> > 
> > Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> > Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> > Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
> >  1 file changed, 23 insertions(+), 23 deletions(-)
> > 
> > -	if (snp_reclaim_pages(__pa(data), 1, true))
> > -		return -EFAULT;
> > +	if (sev->snp_initialized) {
> > +		/*
> > +		 * The status page will be in Reclaim state on success, or left
> > +		 * in Firmware state on failure. Use snp_reclaim_pages() to
> > +		 * transition either case back to Hypervisor-owned state.
> > +		 */
> > +		if (snp_reclaim_pages(__pa(data), 1, true)) {
> > +			snp_leak_pages(__page_to_pfn(status_page), 1);
> 
> This change got flagged by an experimental AI agent:
> 
>   If `snp_reclaim_pages()` fails, it already internally calls
>   `snp_leak_pages()`. Does calling `snp_leak_pages()` a second time
>   on the exact same page corrupt the `snp_leaked_pages_list` because
>   `list_add_tail(&page->buddy_list, &snp_leaked_pages_list)` is
>   executed again?
> 
> I don't claim to understand the code, but it does look like snp_leak_pages()
> is indeed called twice on the same page, which does suggest that it is added
> twice to the leaked pages list if it is not a compound page.
> 
> Does this make sense, or is the AI missing something ?

Thanks for flagging this, I agree. I think we can drop that call:

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..bd31ebfc85d5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2410,10 +2410,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
 		 * transition either case back to Hypervisor-owned state.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true)) {
-			snp_leak_pages(__page_to_pfn(status_page), 1);
+		if (snp_reclaim_pages(__pa(data), 1, true))
 			return -EFAULT;
-		}
 	}
 
 	if (ret)

Double checking other uses of snp_reclaim_pages(), I don't think
anyone else makes this mistake.

Do you want to send a patch? Otherwise, how do I credit via
Reported-by:, to just you?

Thanks,

Tycho
