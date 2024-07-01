Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D20417108D;
	Mon,  1 Jul 2024 20:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719867323; cv=none; b=FX+QZIr5qE5t4THNpExalUkWk4veDTc3rjmGiU2npUSBKM1CwhhitFRb1xbu9heMJjzy02dh6kI8d75tUY6/KLVGLQYiUfSzfW1fgTkk2O1u5ml7vxgjwUN0nwauqEX7EFn4Ona6s40oTsbXbsa9u9Px1mV/2ZLMipMJczrbdqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719867323; c=relaxed/simple;
	bh=ccCNvlPvitLrFUNbB59+klivWsSH/qMEMhKBAz5irNg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpY4CPyo9Z9BFn92lrurHeL8PedSU+G0NNi2v3syRNvhhSyMegttUSGWTDcuZrO8wapQ6VSW6d3t1XSo/SahO+kNamgfxXBfk/nacht9qFuHY9Zgu0qTuBjChcGtKuvNsHadbgZdeQkFJEDby9rX0b6jfoTHXp/4ichlWpLGDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ean99Tba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ean99Tba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E729C116B1;
	Mon,  1 Jul 2024 20:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719867322;
	bh=ccCNvlPvitLrFUNbB59+klivWsSH/qMEMhKBAz5irNg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ean99TbavhafoA5g+v6yuVoPFhvlW9VhLqHyqdAdTRQYuvr2mavkjCBm++ClDA2+I
	 RSH+STG1M76y3L519+gNN1oR0SN6VXvAWoTyxGTig4TJsXAKr5Ux+GLdiXwxs4cMfd
	 t4nPfATGlNRFYY3F1Qd8/UCeftSW6ltuOURZxU4pXQawDVzYfiBS3seyk9Muyx/cBT
	 v26nCspBpM/5Au6xX4xXkH1hLCVB+eJ9/vlYA6kC9pJOFadwdIN0qF7qFkANm2dAoq
	 ESjfV6vZl6xc0w3KbiNEPDD89/pql4UbjPUizB0qn0pX0qrVjKZWph1QEUc62Eb1Yv
	 6K88XHw9uamwg==
Date: Mon, 1 Jul 2024 13:55:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: kernel test robot <lkp@intel.com>, Breno Leitao <leitao@debian.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, oe-kbuild-all@lists.linux.dev,
 netdev@vger.kernel.org, horms@kernel.org, linux-kernel@vger.kernel.org,
 Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [PATCH net-next v2 1/3] crypto: caam: Make CRYPTO_DEV_FSL_CAAM
 dependent of COMPILE_TEST
Message-ID: <20240701135521.3ba809bb@kernel.org>
In-Reply-To: <202407011309.cpTuOGdg-lkp@intel.com>
References: <20240628161450.2541367-2-leitao@debian.org>
	<202407011309.cpTuOGdg-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 1 Jul 2024 13:48:21 +0800 kernel test robot wrote:
> >> drivers/crypto/caam/ctrl.c:83:34: warning: 'imx8m_machine_match' defined but not used [-Wunused-const-variable=]  
>       83 | static const struct of_device_id imx8m_machine_match[] = {
>          |                            

Reading 5762c20593b6b95 it seems like hiding the references in
intentional. You gotta wrap this array in an ifdef for non-OF 
builds it seems.
