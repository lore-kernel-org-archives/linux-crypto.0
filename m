Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201B24BD1A;
	Fri, 13 Jun 2025 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807456; cv=none; b=bxeUKkW4DewEUbqisgComIxY+QZh5PF6oSUZnzScol1PgvWN7W23HVs6XFEpXlvj0hkHOf4qzpjfBwiiOe0emNPmSjt7iMvC14ict5DesQYAKqBDQ0D+KXPQoZlTCSx18Y2DD0cGVH1kYDOltEinA4NNjrkxu0YOQ0KRJ9xuLQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807456; c=relaxed/simple;
	bh=LVGyPoTvGZsBOzqQfrIsvNze7QqZjHs9OK9VMHDYCqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vo/Q8uieGnr8aU1PTOwACMfyjHxw+2nY94Jhx59jgNUWiV77F+Ts56xlB1uNWEv5dpt/afEX2dHjTtPKH4CkxQV6aOILCc5Tz7n397VLkMXIbKLIV/WLipN96rzsF8r9v6NdHI7le6anQuMA1V/F9CYQKzs7M759xgPraUwYKwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mcS8bw6V; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mcS8bw6V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Il348ew1NcDZnfG/kOxQ1x1yaRu/XX/vljLMeyjCTRw=; b=mcS8bw6VPavZ04H3b2/teVgcnQ
	UPEES/MxnjAw3RdSQtDCM6hY4+7yAULub59MhAIqklbtzvKl1U59T73sHlvrmsAcPqTAjn3ZHc2/2
	lC565uPQU2WT4MOYd+YAyBTU6HYG1DMw20fZYSYLx3BpMeCVYXDFIeHP/WXacFVGZnZWFLzaIGTZo
	IX3Q36r3a2WqmXVnqqBUnWThH8Avx0saFXIpK4rAKWQPFXhIHLAWpoG8fMVM0TzC+p7qSDQnWBqij
	JJxwrqhFey78rh3pwHP+EMCydDJTTPayLQQA8TfZcmZiq0L8B+H7ih1SkoOpQA/zHZb2YFkm1NFfb
	2LBp4LIQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0qg-00Ct2Y-1Z;
	Fri, 13 Jun 2025 17:37:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:37:22 +0800
Date: Fri, 13 Jun 2025 17:37:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amit Singh Tomar <amitsinght@marvell.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Shashank Gupta <shashankg@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [PATCH 0/2] extend engine group handling for Additional types
Message-ID: <aEvxUlNBAbtYln5i@gondor.apana.org.au>
References: <20250528145941.2659706-1-amitsinght@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250528145941.2659706-1-amitsinght@marvell.com>

On Wed, May 28, 2025 at 08:29:39PM +0530, Amit Singh Tomar wrote:
> The Cryptographic Accelerator Unit (CPT) on MARVELL platform supports
> different engine groups to execute both symmetric and asymmetric
> algorithms. This small patch set introduces minor enhancements to the
> engine group handling logic to ensure the correct group numbers are
> obtained for AE and SE.
> 
> patch(1/1) 
> 	* extend the otx2_cpt_get_kcrypto_eng_grp_num() API to support
> 	  retrieving engine group numbers for additional engine types.
> 
> patch(2/2)
> 	* Add support for retrieving the engine group number for the asymmetric
> 	  engine type.
> 
> Amit Singh Tomar (2):
>   crypto: octeontx2: Rework how engine group number is obtained
>   crypto: octeontx2: get engine group number for asymmetric engine
> 
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  3 ++-
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  3 ++-
>  .../marvell/octeontx2/otx2_cptvf_algs.c       |  6 +++--
>  .../marvell/octeontx2/otx2_cptvf_main.c       | 26 +++++++++++++++----
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  7 ++++-
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 14 ++++++++--
>  6 files changed, 47 insertions(+), 12 deletions(-)
> 
> -- 
> 2.48.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
