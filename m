Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794607008;
	b=KQgqP6O5xlSz/M/rtVM0l62Yn6iZZmgpDZsHx7a43ccjKR9OUDIc/T3ZKsslWvN0JIKn
	 KXw3tecEzOeoGGu9Jwg/jzXTukPtHVoQgRUrnYkeqRbVGCP3zFAC0LQU4Pf10XH7eVsLe
	 43DJCJ9qXMv90WwyBc7xTK7Be2RdY7Ox5IKM1SlNTiKVVf2RbxKfF3elsuxvh384lAY9R
	 /Vi26afmGb28pM6D48KkeZWSfBqkyNSGiSedfQjqdN3P7lMSlWz30wCLyrMyhpCSghShA
	 AvT25yvJZfrjQXwXpc2pbNkBheo2gwnooLUXnofK5UCxycLxlLhFRXRAcxinbJgNZEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607008;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Lojet1UabwWhCaLz0Jyo5vGlfCJJoF5zcHI8Xx+5gjM=;
	b=hLTfmoMOTN4z+M8uPyxoReTuwa9r2jAkdgrLy24wbp8QoKmcMfG+3Cg6pUBHaC8GEolb
	 ATwo8dI8wT3FGTIbejAlwFUsDDmXgnVmisUvbFC3GvOoni0IR83p0f8FPBLaqwuk+MLoM
	 9V6cWktSkenpwKeGa5YrcAFZWVN8NCvE4Ip/qxI6hIp/weeBYv8pESETIB5cMjczZk7Yg
	 5mV0PFaxiqdFGQDRuOXcNdC52Zr6bm1k/tWzCE5yGssJUs7tlOA5eP/ELHInx8LGbLG51
	 czb5tEzWwSgSVgi32JRk+MtpikJWCE9JVSpf4qxIYm21hWETxSNkALHptT2ld9yCTUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JE5ejKnt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AAE606A332;
	Fri, 13 Nov 2026 21:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JE5ejKnt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01791F000C4;
	Fri, 13 Nov 2026 21:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794607008;
	bh=Lojet1UabwWhCaLz0Jyo5vGlfCJJoF5zcHI8Xx+5gjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JE5ejKntaY2WEDXp7SsdZZ3sYaSE/50lr33SUvoXrVgbz1IEUICvM6iODFu1r8/7T
	 U3BVvn4W4D2R4dkxrijHoXQeaMDzp2DSLjX5dm8j27A725GwcLW4cLhMSISydCAVSS
	 QhTsQUgfADrz4Nir/lR9c5MIF39OlMjmxClHO56i7QkQREYubcTwPr5Aprd1nv6kOz
	 nJNYNpp2LLhBtcWqNNt3dvLDsOdX+3WioV97IXYqdQq1DetNMz6TsOBtaRo791Pt3S
	 Mgj05P3aVcKLQRyQTSOF6pm3NZvQlx116s7pt6eMkEVqZFNAuUfRuIxynSHDNSxmV/
	 EJ8i/dYrhOw/Q==
Date: Fri, 13 Nov 2026 13:56:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
	Basant Kumar <basantk@qti.qualcomm.com>,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 4/6] tee: optee: Register TEE devices on the platform
 bus
Message-ID: <20261113215646.GB35210@quark>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>

On Wed, Nov 11, 2026 at 07:47:04PM +0530, Harshal Dev wrote:
>  module_tee_client_driver(qcom_ice_tee_driver);
[...]
> +module_platform_driver(qcom_ice_plat_driver);

So is this a tee_client_driver or is it a platform_driver?  It can't be
both.

This patch feels like a workaround for issues that could be solved by
folding this driver's functionality into the existing qcom_ice driver.
Is there any reason why qcom_ice shouldn't just make the OP-TEE calls
directly?

- Eric
