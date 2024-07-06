Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A60A5258
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jul 2024 00:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720226986; cv=none; b=cyelJlkNK4fHU4Vx/JOW4IO6rFVRjvc9gd17L/pSSeHAmmC68YXSwPUEFF/pgDAcC2tF7ZwwXqC4b7CvqdoSrvdu8BgdBpQOFI8HTlJYfJpvEdl/OTZsOBKhzk70hsdy89Wr+KL7V5om4uOjVAjKk8JzkcRzh/c2LtFzJeIZFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720226986; c=relaxed/simple;
	bh=GllFxXDdp/x7cHS2kXyeCm3Y2TSfHInjA4HgUYeNghk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWCmtAn0fee+ra6WpBKqAQPAKiO4h09r2As3Ibm8CjiuKc/0Hoq/MBLkvR6TDaskELwM5wezg5Nqd/nx6AVKVevI71S/3x4tyqIYxXLEB6kZSzEP+LFHj2onQiEzWbqzRljcovN4b+v2pvCv0BAmnYkwhfGhMBay9e29U1vFYQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPtcT-006h1y-37;
	Sat, 06 Jul 2024 10:49:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:49:29 +1000
Date: Sat, 6 Jul 2024 10:49:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] crypto: qat - fix unintentional re-enabling of error
 interrupts
Message-ID: <ZoiUmemLbcC0hi7m@gondor.apana.org.au>
References: <20240625144139.6003-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625144139.6003-1-giovanni.cabiddu@intel.com>

On Tue, Jun 25, 2024 at 03:41:19PM +0100, Giovanni Cabiddu wrote:
> From: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
> 
> The logic that detects pending VF2PF interrupts unintentionally clears
> the section of the error mask register(s) not related to VF2PF.
> This might cause interrupts unrelated to VF2PF, reported through
> errsou3 and errsou5, to be reported again after the execution
> of the function disable_pending_vf2pf_interrupts() in dh895xcc
> and GEN2 devices.
> 
> Fix by updating only section of errmsk3 and errmsk5 related to VF2PF.
> 
> Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
> Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c       | 4 +++-
>  .../crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  | 8 ++++++--
>  2 files changed, 9 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
