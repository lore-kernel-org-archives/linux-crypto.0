Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C63152DE7;
	Mon, 21 Jul 2025 02:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753063607; cv=none; b=ZaNPkh+FQBWB29aRgBHEKZCKx/eHgHNpUdFL/pKnukTN9lhMROeNkqimyvi9WwmBaA/f+JuwZPOhN6rqwZTA3swEln/AUzKag0cwjC7Rpnn2mF3xSdYlQj/yO/MTI59R92YqXYN5/OFYaRzTMD4DteGyuOZB4cKXbShzVuEa0iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753063607; c=relaxed/simple;
	bh=9eZkC0PdV9yKIm2Zi5vo1UTwAxcTufu2rNkpEGpnkpE=;
	h=Date:Message-ID:In-Reply-To:References:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=EMNdWHndQ1H3femhDaKxb/N4F/uxkPp6ASPtEd3MUjCoRFpL6OerteSPsCUTRsKkAA6Th5bNaMuCteb54Fo7pIUo5j4ChXWxFHCFgOXfLlE7DIdD70SS1Hx2S9XdWz+rq5E7Pk9c0WnWua9SO1he+Sd9EBGGGKDORCznLw5lHBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4blkKQ0Zb7z5B15L;
	Mon, 21 Jul 2025 10:06:34 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 56L26H4l035451;
	Mon, 21 Jul 2025 10:06:17 +0800 (+08)
	(envelope-from zhang.enpei@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 21 Jul 2025 10:06:18 +0800 (CST)
Date: Mon, 21 Jul 2025 10:06:18 +0800 (CST)
X-Zmail-TransId: 2af9687da09a406-b51bc
X-Mailer: Zmail v1.0
Message-ID: <20250721100618249bnR0yTtsh0IeGzAdt8Fuu@zte.com.cn>
In-Reply-To: <e4c297a7-1ef1-4c39-8daa-8acdade47508@wanadoo.fr>
References: 20250719163416760SUAwKHXRQRBFKhvAOpNbT@zte.com.cn,e4c297a7-1ef1-4c39-8daa-8acdade47508@wanadoo.fr
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <zhang.enpei@zte.com.cn>
To: <christophe.jaillet@wanadoo.fr>
Cc: <horia.geanta@nxp.com>, <pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gY3J5cHRvOiBjYWFtIC0gc3dpdGNoIHRvIHVzZSBkZXZtX2ttZW1kdXBfYXJyYXkoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 56L26H4l035451
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: zhang.enpei@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Mon, 21 Jul 2025 10:06:34 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 687DA0AA.000/4blkKQ0Zb7z5B15L

Thanks for the review!
devm_kmemdup_array() will call size_mul() to combine its third and fourth parameters into
length for devm_kmemdup(). So keep the same value sizeof(data->clks[0]) here as before.
