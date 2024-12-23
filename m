Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73475188CDB;
	Mon, 23 Dec 2024 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734986673; cv=none; b=W4la8w5NLBrZPRev1K/3Z2grsSSb7RPa/WXiVuxPGFuYlS3/lhkdajH6T40CyGGP8Pt6dOFlKxb2J8gevbdkLZCAT7z6JbbTB7PkNLykjem/9Udl9iB9Pou58MM5ckCGW95prcrVyx4DG0o2j4Dyx1srJhq+0Fq3ZCM9rb3827A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734986673; c=relaxed/simple;
	bh=/IHoBxSjsaCAQlSKqA2pfkH1SPJIuYj9VLfq79j+GTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7l7evnGRemejppKBcDQMCH8k3pjWLj2w4VhqDuBhfBWICwb+wwY/lYJ1pP2XP60calRs2Yec+aygUAiV6pBdINfmKLJ3ulV4Vtng9QC3O425OuThfMU8fgk9PldF9pjNre3ldTWBB/P+K3JEwC/MsERgBUuDKAkrrk2CqzCMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fesnKRlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fesnKRlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F4C4CED3;
	Mon, 23 Dec 2024 20:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734986673;
	bh=/IHoBxSjsaCAQlSKqA2pfkH1SPJIuYj9VLfq79j+GTk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fesnKRlDWGVm7gY8QaNyRCVlvf0xEvTe5uS3bn3ZcmIf5ie1mTLDAtQqM1w5Aqd3K
	 T0+HSmzfGibuUZ4jjPC7SLwsbE3+Gw84Ca7VM8hfIwlCrDs/CpHBTFAp12AWq9Quq8
	 fI14QyQHdz/mdlFM11aAZFD31L3CzwbPkpQy/UNmwG4Epy6VOQm99k8YrbwiZfjYAs
	 mfR3U0g58zCdBH3QuPSM31fHPLtENxfO5wchKIbPiOtS1/E2iEBaTc3XMBMR90Wafp
	 DcixWqZeA+8CyXdTizAAt0JQcy2S1Gd5rhfZXmfg2jbHi4oMOjogCPx5Rrn9h45aW6
	 nun0BvnVt99FQ==
Date: Mon, 23 Dec 2024 12:44:31 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 26/29] net/tls: use the new scatterwalk functions
Message-ID: <20241223124431.1d34888f@kernel.org>
In-Reply-To: <20241223194249.GB2032@quark.localdomain>
References: <20241221091056.282098-1-ebiggers@kernel.org>
	<20241221091056.282098-27-ebiggers@kernel.org>
	<20241223074825.7c4c74a0@kernel.org>
	<20241223194249.GB2032@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 23 Dec 2024 11:42:49 -0800 Eric Biggers wrote:
> > Acked-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Thanks.  FYI I will need to update this patch in the next version, as I did not
> take into consideration what chain_to_walk() is doing.  This code seems to be a
> bit unique in how it is using the scatterwalk functions.
> 
> Also I think the second paragraph of my commit message is wrong, as the calls to
> scatterwalk_done() in tls_enc_records() are the ones I thought were missing.

netdev@ only got CCed on this one patch so TBH I have trusted 
the conversion :(

FWIW tls has a relatively solid selftest:
tools/testing/selftests/net/tls.c
