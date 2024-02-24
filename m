Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C939D1864
	for <linux-crypto@vger.kernel.org>; Sat, 24 Feb 2024 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708735870; cv=none; b=eR8pqEu4m4xfIsaKWjJexBiWxGjfLbp6ZkE4bQJVvDUbgclxrCR/9MPqug0J6JhoH9x/j3PkrEz+XWCfx2vncXvmFq6nTlGWO1HICcvE8aaG6g0TXZkzrW5sIyho8ICYbgQJYq9JRkiprllpvOs/tC7VZR0tAiQnqs2vklQb/tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708735870; c=relaxed/simple;
	bh=Tx8QJFbihMA2dtuOXPZCxecF73Op+GYtbHDdV8Pp1+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJ0vViHvZ3IgQgFOqo9rVsaB0nfxo2tmCEHgTnVr2OfiK6anFY1hPi08YWBal1fkp2pQV2nnlNlrVwPEIjG2IP2Kp/8h3QBuhjzqyRFVFPbFV36FQ1bV39CYz2Ql6MgivAgPkuADn2lX+cQRiRu1+PpOS5Zb2mMvoGEeigSruvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rdgFs-00HDy8-Ng; Sat, 24 Feb 2024 08:51:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Feb 2024 08:51:19 +0800
Date: Sat, 24 Feb 2024 08:51:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adam Guerin <adam.guerin@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/6] crypto: qat - fix warnings reported by clang
Message-ID: <Zdk9h3SFGS2Wzejf@gondor.apana.org.au>
References: <20240216151959.19382-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216151959.19382-1-adam.guerin@intel.com>

On Fri, Feb 16, 2024 at 03:19:54PM +0000, Adam Guerin wrote:
> This set fixes a list of warnings found by compiling the QAT driver with
> "CC=clang W=2" and with the Clang tool scan-build.
> 
> These fixes include removing unused macros in both adf_cnv_dbgfs.c and
> qat_comp_alg.c, fix initialization of multiple variables, check that
> delta_us is not 0, and fixing the comment structures in multiple files.
> 
> Adam Guerin (6):
>   crypto: qat - remove unused macros in qat_comp_alg.c
>   crypto: qat - removed unused macro in adf_cnv_dbgfs.c
>   crypto: qat - avoid division by zero
>   crypto: qat - remove double initialization of value
>   crypto: qat - remove unnecessary description from comment
>   crypto: qat - fix comment structure
> 
>  drivers/crypto/intel/qat/qat_common/adf_clock.c     | 3 +++
>  drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c | 1 -
>  drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c   | 4 ++--
>  drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c  | 6 ++----
>  drivers/crypto/intel/qat/qat_common/adf_isr.c       | 2 --
>  drivers/crypto/intel/qat/qat_common/adf_vf_isr.c    | 2 --
>  drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 9 ---------
>  drivers/crypto/intel/qat/qat_common/qat_crypto.c    | 4 ++--
>  8 files changed, 9 insertions(+), 22 deletions(-)
> 
> 
> base-commit: 7a35f3adf4535a9a56ef7b3e75355806632030ca
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
