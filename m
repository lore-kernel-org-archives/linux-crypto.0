Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF625B098
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783511283; cv=none; b=QblFummPE75y/5fZ8r8nQ4+2QexO5GLafNoTl1/sWif/Vaykt2eAQZuzsAf6/O7n+2eGou72vD8Ol/9UiwWujPTq5weCmaCmI4V6Qfq4NWZmOG80ekPq5NEnLprFhxoma4t6HxCyn/LQk4mu4MrqB36Y8lbaKN8gSyC3kNZWnSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783511283; c=relaxed/simple;
	bh=IetCGXWXYWCABI80/6epRSKDrVdkcLbcXAzdYDCs7PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqVOTHdiYHWdjqVlnuuIPjFp3MQBIxdwuecN8PeBHAhrCkzx5lmKHVHuIRzoQanmV3xhu0iF/0C39OSlpM2FtdTmha9gBxlDQnHdsa2AoovtTm/LcFfBpa/ub4UxN3AUgre7Exi5Uo2ogGF49ttAe3NmvzCAxWpMMNm61zqpvKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wH+TRYQF; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wH+TRYQF"
Message-ID: <5f9c3aab-5339-463c-a86d-edac297e1e95@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783511270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tm9tdXVQf7m0O40Z8MsrsbGx4LS72vUMtDlVHVMuumU=;
	b=wH+TRYQFB5IsjW4winIj02WnSNbqb5VJlU95ox14vGIP0Ayf7LKBxWtaiE7jz8SU6V7pCX
	BMHT/pHd4UE0+EnibAaJuR6vGiviV+q1faosLGblZ5Jk3LY2DcMRLp9CWs0mHAKK8Wm8LL
	DlL3YOFPqlZ0blMgwui6/3E+/Bij+m4=
Date: Wed, 8 Jul 2026 12:47:43 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf <bpf@vger.kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
 <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
 <20260707182049.GA2238@quark>
 <d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev>
 <20260707231652.GA2264445@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20260707231652.GA2264445@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 08/07/2026 00:16, Eric Biggers wrote:
> On Tue, Jul 07, 2026 at 11:50:33PM +0100, Vadim Fedorenko wrote:
>>> Does this mean the AES-ECB support is unnecessary and can be dropped?
>>
>> Let's keep it if it doesn't hurt.
> 
> It kind of does.  It is "bad" crypto that would have to continue to be
> maintained, and someone might start using it accidentally.

AES-ECB was introduced as a cipher to use in QUIC-LB draft,
draft-ietf-quic-load-balancers-21

I know it is expired draft, but it may be worth keeping this cipher
as QUIC WG github is still active
