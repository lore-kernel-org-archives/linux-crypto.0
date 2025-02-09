Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFD616EB7C
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 10:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096724; cv=none; b=dIrablQ2+2+wTivSQtekP2LNZBJAvEc3uS4x31KoxcpjZ3h+9DFYCKQvd1NXtzkRpW5mtEzx4HueASNTgQY8IHuMNC5II0uJH5tEbthmQThqVNu50STgMwL5qGdjF9rFQqL0bRv9Mxc6nui0XqlYKsPOVV/j5JQLy7rZ2gyR/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096724; c=relaxed/simple;
	bh=V3sKsXexpzB0HCBB1zyLyPENhrHhIutJd1BaKq3MWMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4/xw1DLyb24A3qj7IthliNyi7CpoOQTN46iM9Is4Cjoz6pdB+I0dQ+BFAxfzOfQV7eD8U3VYk38Qe7380PvuUt3S/o27GuO4AAyZjUozHalUNuKq0Q3MhTDBQ78b01V+sUhSj5fIDvWR+H4QYp2xEaaeSiGTT+okxVktJkZgBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CtzrMa5Q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CtzrMa5Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y18cA3R0JYeos0enClTV+gbA9D0KY9KLed/cG/prBug=; b=CtzrMa5QvVf1uHBO8U39/e/CP6
	vPsZpLVOSLXDejyWsWdN48BMTShfogpXH7VrlJ22UZaYVt7UPAZftCMomVJlLDRRj8WIpbGpFuy1I
	OvPeVoYZxgV0xhtBSSGqVsyOjJUed5rzvLf/EJWbwzRtAht7R230euDr524MUA/apER848JLsn4PH
	A/LzNajUBx3OsuYnjMYCqvf11eYi2uDXxr+WsWr7E7m1VCBvehf/vsyf4u/V3SuPMBko+Fv8dqT5j
	zkTvIk0WGSV/sTF2La9ECcsQqwIaFTJyhuzReP0LLL1I6jhPwb83Z01G2j+YcCTA4KcUJPJOGVqQd
	GKF4YTww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4I9-00GIs7-1m;
	Sun, 09 Feb 2025 18:25:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:25:18 +0800
Date: Sun, 9 Feb 2025 18:25:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [RESEND] crypto: qat - set command ids as reserved
Message-ID: <Z6iCjt7I4aAiDv-A@gondor.apana.org.au>
References: <20250131113454.3269995-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250131113454.3269995-1-suman.kumar.chakraborty@intel.com>

On Fri, Jan 31, 2025 at 11:34:54AM +0000, Suman Kumar Chakraborty wrote:
> The XP10 algorithm is not supported by any QAT device.
> Remove the definition of bit 7 (ICP_QAT_FW_COMP_20_CMD_XP10_COMPRESS)
> and bit 8 (ICP_QAT_FW_COMP_20_CMD_XP10_DECOMPRESS) in the firmware
> command id enum and rename them as reserved.
> Those bits shall not be used in future.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> Fixed headline of commit message
> 
>  drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
