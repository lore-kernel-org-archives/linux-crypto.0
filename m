Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5842C415B88;
	Wed, 23 Sep 2026 08:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153586; cv=none; b=GkAWBa0ubOELIRmhmKAe2rFHWTqsYhO5evb4t3RzXet6arK1jsaREZPdeBbMBOOzQvUlJXKKydKH1xKN1S+JJ59vpR2E22umw9QLiYa7r1sXSEwNtj1UlVwPnt0MMu95hXaUPMf5S471hafpnyA1cltdkTaImAfI26l7zcgFsFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153586; c=relaxed/simple;
	bh=44ikiz+5uyAIozAHOOzCYux2ntsCFP/LOEokfn+LTME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/krTRAFU1CqHBj2XAzydkvHC6tep7MZFOYpRHCC/+25ydah0mBsZ/4ymJprZIdhjYpx+eOJ9exHNIHrCz//3lWLcuJZ/a0Ws+TatA7nBDoLOWCBUQFnvTRRRQJTGmlXHYGjFqD7+qmzb1X4U+512TfeDTSbjvPOt2mq1lICR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QtzvjPUy; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QtzvjPUy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aQkRCfu6VLaqIrKZPPTVlb7vnvc3FPnSvoGW4f04Zb4=; 
	b=QtzvjPUy6hW5EwaEdganTpEyLS1mCvDPphnZKm08i1TBUwhrUDymzUTTOmQoLD2r7ur5S4O5Wkr
	JyEgBCZNw98WyWEtfBB4emCmOIEmTeScbO6sZsf00Pfq1ahPQZBxPEf5pk1rvzjipcBMAqtF14Fe6
	33M6tv56Jxbnn9K0HkEXvmlw2HJbF9X0sea5fyAEds+tP7q3vL8B8GG+4BA/FSa03Vxhjez2t4CGQ
	rmVZqFM3/HgzglgesQWn0w4xPsKDhLJy8EbmQl4x8f3APukNKym3KFZQoJPWoqrTY74XoHX4tpNH8
	f5cGs38tHK3o+ZBXTRJVAykmyuxUQwOrj6jA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Iid-0000000GyHI-2k6Q;
	Wed, 23 Sep 2026 16:52:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:52:47 +1000
Date: Wed, 23 Sep 2026 18:52:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
Message-ID: <arOTX7cLai_Y_MUl@gondor.apana.org.au>
References: <20260918232736.3095763-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918232736.3095763-1-rdunlap@infradead.org>

On Fri, Sep 18, 2026 at 04:27:36PM -0700, Randy Dunlap wrote:
> Clean up kernel-doc comments to prevent warnings in both
> <linux/psp-sev.h> and <uapi/linux/psp-sev.h>.
> 
> include/linux/psp-sev.h: (62 lines; edited for brevity)
> Warning: include/linux/psp-sev.h:52 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform state
> Warning: include/linux/psp-sev.h:63 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform and guest management commands
> Warning: include/linux/psp-sev.h:167 struct member 'reserved' not described in 'sev_data_init'
> Warning: include/linux/psp-sev.h:187 struct member 'reserved' not described in 'sev_data_init_ex'
> Warning: include/linux/psp-sev.h:216 expecting prototype for struct sev_data_cert_import. Prototype was for struct sev_data_pek_cert_import instead
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_address' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_len' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'reserved' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_address' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_len' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/linux/psp-sev.h:446 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_data instead
> Warning: include/linux/psp-sev.h:469 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_vmsa instead
> Warning: include/linux/psp-sev.h:506 struct member 'policy' not described in 'sev_data_receive_start'
> Warning: include/linux/psp-sev.h:799 struct member 'rapl_dis' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'ciphertext_hiding_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'tio_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'max_snp_asid' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:843 missing initial short description on line:
>  * struct sev_platform_init_args
> Warning: include/linux/psp-sev.h:893 expecting prototype for struct feature_info. Prototype was for struct snp_feature_info instead
> Warning: include/linux/psp-sev.h:956 missing initial short description on line:
>  * struct sev_snp_tcb_version_genoa_milan
> Warning: include/linux/psp-sev.h:973 missing initial short description on line:
>  * struct sev_snp_tcb_version_turin
> Warning: include/linux/psp-sev.h:1053 function parameter 'filep' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1053 function parameter 'id' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1112 function parameter 'data' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 function parameter 'error' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'decommission' description in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'sev_ret' description in 'sev_guest_decommission'
> 
> include/uapi/linux/psp-sev.h:
> Warning: include/uapi/linux/psp-sev.h:18 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform commands
> Warning: include/uapi/linux/psp-sev.h:39 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV Firmware status code
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_major' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_minor' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'major' description in 'sev_user_data_status' (did you mean one of: 'api_major')
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'minor' description in 'sev_user_data_status' (did you mean one of: 'api_minor')
> Warning: include/uapi/linux/psp-sev.h:153 expecting prototype for struct sev_user_data_cert_import. Prototype was for struct sev_user_data_pek_cert_import instead
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_address' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_len' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_address' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_len' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/uapi/linux/psp-sev.h:263 expecting prototype for struct sev_data_snp_vlek_load. Prototype was for struct sev_user_data_snp_vlek_load instead
> Warning: include/uapi/linux/psp-sev.h:273 expecting prototype for struct sev_user_data_snp_vlek_wrapped_vlek_hashstick. Prototype was for struct sev_user_data_snp_wrapped_vlek_hashstick instead
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: don't use private: for reserved fields; just describe them in
>     kernel-doc (Tom)
> 
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
>  include/linux/psp-sev.h      |   86 +++++++++++++++++++++++----------
>  include/uapi/linux/psp-sev.h |   26 ++++-----
>  2 files changed, 73 insertions(+), 39 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
