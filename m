Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A178691
	for <linux-crypto@vger.kernel.org>; Fri, 17 May 2024 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.220.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715959234; cv=none; b=m5ZF60qjTMX6KTBSQnsHgiVaDGwRWb5irJEmLnF3C1Pv6S4j8c5knwDcnPYxjL1dQXpkKA3ERbFPgkuyOX+JME4yaRydxtFMYwnZBvSfumEKLal3P0tD9v+xLDlN6itIkmWae8MZtRr5T+0AJVBrj2g1mM1LFSC+5kebftvE9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715959234; c=relaxed/simple;
	bh=A9lXaKyu2w4W/EY02pSVF4CV/3WEY/Vo2bSNLwtrvRw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ca4I1EPpMeK8dTcM2U3ojwHdsZXYtctboVuW94wtd12PRbdfSENGw65UDjgV8X+ax0U586kj+8daEGoqKFueC+FXPtDZ51bejIDrqin4OCpTUPJC32zFharG7pQXEu+Dp/ucNSJ48+FQ1hGvuAamJgwDBcKi2Ly6quoex//rtxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com; spf=pass smtp.mailfrom=mareichelt.com; dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b=d+WnnKzl; arc=none smtp.client-ip=91.227.220.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.b="d+WnnKzl"
Date: Fri, 17 May 2024 17:10:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
	s=202107; t=1715958641;
	bh=A9lXaKyu2w4W/EY02pSVF4CV/3WEY/Vo2bSNLwtrvRw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
	 From:from:in-reply-to:in-reply-to:message-id:mime-version:
	 references:reply-to:Sender:Subject:Subject:To:To;
	b=d+WnnKzl5lgC+O7ux5DXAlzd81Lu4GlvFTOCjlxa7eG/DO/WEbQGQnaX1EkwZeBc4
	 o8CMiFCJJMmdabMe5N4PfzIsTGAz8tybJ/S2jka2ND1AjUU9DKezQDeBJu5dlXrJ+e
	 Yv8cx6Gik31/HEdmQ5JJZoc/w5g5Gp22P4+z3loW6SuCob2pyt5das6Y+PXizKJl3Q
	 wRbIqn+QunpDpL/yAFjNN7EGhllbj1nPQhVK3i7NJkFixKtQFM7MLrzLjefkY5yD69
	 PgsNTnVvx/124I+7WriVnuo4oaxSd5WsmIXIn3XgehSKYXKTAbhXfmU29U/bcXnikK
	 9mmvYTtJg2CpA==
From: Markus Reichelt <ml@mareichelt.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Announce loop-AES-v3.8c file/swap crypto package
Message-ID: <20240517151040.GA12834@pc21.mareichelt.com>
Mail-Followup-To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <o3EitVdfjzMQYFYoBUvjc5k5gG34HDyHO4_y8URvnISYtxVO-kLk1vkgHit-pnyFWENk6qvROkowKsaJT4_OYcCGhaUzuEv7XbwpmjU2i64=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <o3EitVdfjzMQYFYoBUvjc5k5gG34HDyHO4_y8URvnISYtxVO-kLk1vkgHit-pnyFWENk6qvROkowKsaJT4_OYcCGhaUzuEv7XbwpmjU2i64=@protonmail.com>

* Jari Ruusu <jariruusu@protonmail.com> wrote:

> - Added assembler AES implementation for 32/64-bit ARM for kernel patch
>   version only (see kernel-arm-asm.diff). That assembler code is not in
>   externally compiled module.

Is there a reason for that? ^^^

Thanks, Markus
