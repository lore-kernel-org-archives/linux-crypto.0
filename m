Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA982231A21;
	Wed,  7 May 2025 09:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746610120; cv=none; b=ZSndMc6RA9mB7/HOQaEqrBectb3AkrP7Eekp06TU641dDvu0jOHbS7KTzwwj95RVZA6ECwDgemRiaDINHoHmLRRhwXkx3DmhOMNQEvxzAqF2j5PAdboxTBFwrmhbdcygjv4OsoUKJhToqMQG5I7Xxn03eebjy6x0OzBbX72LWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746610120; c=relaxed/simple;
	bh=rhGBWocv7dzYv4/rcPMuwMy0PtwENsCm+mrizK+pw9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Magvl6sqou92gs4cfyVz2fS0SKhI2pfSYd3H+HWUogYTNfSTRDq5DBmhaUZmKHiQ02wntJS4BLzUqRHTBxDYzsrgnmBAE9ljzw02weYCvNBA2Nqcff8ofNuv7/1/Am9Bh6jzy/VKG0795DBPKytFwoxklQ3Ryzq4RQZ+e4+umiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aK46KEfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aK46KEfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AEBC4CEE7;
	Wed,  7 May 2025 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746610120;
	bh=rhGBWocv7dzYv4/rcPMuwMy0PtwENsCm+mrizK+pw9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aK46KEfQwTZi2NPYqxCCueOwl31jY0wQNMN5m41GEoIERfBVf7Q+EknHSetwxAI1J
	 GfunrIyecV+aRVyLoSuja4rxl9dj/s+fLWJuzs6RT1i0DiG9PZMcTUAphOIVXqyv1N
	 1tFi7Mrs792C3lXOwJgHgzGMF7XfmemL5xPjFK5n3TmsAHSjynGTruyq1uav4Oke1Y
	 RcmN8/mw2oOoa9fvHRgBUTFxVnCIjRY4nQIBOIaH6x5UJEB3cIHPwMpzr8OcoMpVPZ
	 XwrUcetAOSOvBpQBZGR8h9z0L7QCXa7/F3NeIlbJvtypzhixpBeEQnfgvD9fF71mhL
	 D7859XxViezwQ==
Date: Wed, 7 May 2025 10:28:32 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
	jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bbhushan2@marvell.com, bhelgaas@google.com,
	pstanner@redhat.com, gregkh@linuxfoundation.org,
	peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com
Subject: Re: [net-next PATCH v1 04/15] octeontx2-af: Handle inbound inline
 ipsec config in AF
Message-ID: <20250507092832.GA3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-5-tanmay@marvell.com>
 <20250507091918.GZ3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507091918.GZ3339421@horms.kernel.org>

On Wed, May 07, 2025 at 10:19:18AM +0100, Simon Horman wrote:
> On Fri, May 02, 2025 at 06:49:45PM +0530, Tanmay Jagdale wrote:
> > From: Bharat Bhushan <bbhushan2@marvell.com>

...

> > diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > index 5e6f70ac35a7..222419bd5ac9 100644
> > --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > @@ -326,9 +326,6 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
> >  	case MBOX_MSG_GET_KVF_LIMITS:
> >  		err = handle_msg_kvf_limits(cptpf, vf, req);
> >  		break;
> > -	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
> > -		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
> > -		break;
> >  
> >  	default:
> >  		err = forward_to_af(cptpf, vf, req, size);
> 
> This removes the only caller of handle_msg_rx_inline_ipsec_lf_cfg()
> Which in turn removes the only caller of rx_inline_ipsec_lf_cfg(),
> and in turn send_inline_ipsec_inbound_msg().
> 
> Those functions should be removed by the same patch that makes the changes
> above.  Which I think could be split into a separate patch from the changes
> below.

Sorry for not noticing before I sent my previous email,
but I now see that those functions are removed by the following patch.
But I do think this needs to be re-arranged a bit to avoid regressions
wrt W=1 builds.

...
