Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.42.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216268;
	b=DCXbH3v+lTnVutOpqrvQEAjocCRvaGqKbdqVXTNl9t+N+DaJNsMUn6IpIoBpTGJ8DYTM
	 J04al3Vtfm98bFECP/eu+yXhcw8DQ+WTXKFz2U04zS/orn8KNJmPHyA5nsUkiKL/kd/7N
	 WMViXawpA9f8EFp8a6cbVSo5q2c7a12X4n26CwoWxY+AM8sb6m8jkGYd9Hpkgl0tFetsM
	 C7f478DpUck6DzHSzR2L35F1uaKAtYIbm5DMGMXKb1gqEXA9UIlagWaKibH2TvJsMEDT9
	 dhJVSmoDAwM64f2rBy8DEQMKE8tGbvUEnzVmNIr3e0vq+87qlVeNGT90YzVdBoUMPhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216268;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=6zSslAcgLSDpoJlg4DDhAvmXHB18Ak1qiHeBJZawCiE=;
	b=xLesnShoR/EZsDkWRyLLz6tQ4+qKYxT4zCSQ7pf8T5BK2+2BzuPu+A/Vff3DA48qXdY8
	 EAVYdKu/fw4MSw+DgNYCP73jVmXsH07N0I6UImzufQivkfKiiJNYwPfysZ/3Z/qhZ2HVz
	 /swpTxmRWNFy+ys5osP2EZjG3L+zZsSpvZCjj2778AT7us7u78QeTGf4UBDnS3re9uBuR
	 uIfK/xo6iRguNFRrlDEChKhpPspLRoHigZq8MJuLL1fz4hXdelqUK4XrC1ywiM2T31olu
	 8sFQ0Im8/HgiRs7p2dhIwpGGoaT/ogf3Pc84bply67Y0E3Ykke0Q+3t18JYEed88VrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=free.fr;
	spf=pass smtp.mailfrom=free.fr;
	dkim=pass header.d=free.fr header.i=@free.fr header.a=rsa-sha256 header.s=smtp-20201208 header.b=LuApu94a;
	arc=none smtp.remote-ip=212.27.42.3
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB0606D80A
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 09:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDEB0606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=free.fr header.i=@free.fr header.a=rsa-sha256 header.s=smtp-20201208 header.b=LuApu94a
Received: from L30177.local (unknown [82.65.104.223])
	(Authenticated sender: vjardin@free.fr)
	by smtp3-g21.free.fr (Postfix) with ESMTPSA id 00DCF13F88F;
	Mon,  9 Nov 2026 10:24:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1794216253;
	bh=4CPZ+2D+MohnvaVvAPW41N5ZGuWYUqT+prNnmrrnU/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuApu94a/jIJ5ETrgixMMjj+1upOLRTfD1qB3ZoxLYnWm7zhUD3qM8eKTzrHeYKNS
	 8WZ3iq7U4sHdOtlOPzlrZ6kypytrAMXpc868xBlprcJkRuq6gSWSBV+e9Df/CwQcEI
	 9Fq9S+6cor1E7Y1fXwXVcd8qeJx8c3LTR6waH97hq4/M8me3Jw42DcE4TN0mjQ2GiA
	 H013mkF6bBEwshi2vCiA5VnnhlWkX30ksQa2eq+CA1lAfYAdYJIA+t4IlpJC5kilel
	 KdPS8LXyhVoW6EtBI8F95p+eBL8ai5LiTuV8DTJB/qExzuth33HG5GvQb3KQNLW12f
	 JfYKRwxBpkWDg==
Date: Mon, 9 Nov 2026 10:24:04 +0100
From: Vincent Jardin <vjardin@free.fr>
To: sashiko-reviews@lists.linux.dev
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC] crypto: caam - never share the gcm and skcipher
 descriptors serially
Message-ID: <avGRNCLts4SX3NgX@L30177.local>
References: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
 <sashiko-outbox-204176@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-204176@kernel.org>

Hi Mx Bot,

> [Severity: Low]
> With HDR_SHARE_NEVER, should HDR_SAVECTX and the JUMP_COND_SHRD jumps also
> be dropped from these four descriptors?
> 
> All CAAM job backends defer sharing mode to the shared descriptor header,
> so HDR_SHARE_NEVER disables descriptor sharing across jobs and JUMP_COND_SHRD
> is never true. Keeping key_jump_cmd and the JUMP_COND_SHRD branch in
> append_dec_op1() called by cnstr_shdsc_skcipher_decap() leaves unreachable
> instructions in the descriptors that waste space and DECO cycles on every
> job, and HDR_SAVECTX only applies when a descriptor is self-shared.


Right, both are void under HDR_SHARE_NEVER: the SHRD condition never
holds, and Save Context only acts under serial self-sharing (SEC RM, HEADER
command).

They are here on purpose for this RFC: to focus on the change under discussion.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr?part=1
