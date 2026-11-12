Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522548;
	b=VDZU2wJe2j4j/qGZzNNRUQwWJ0ElHJH0c1jTQ25Toam10BVmtRn+4hFSy1KInGWZOrRC
	 L3tCRO9+4siRsq4qCv+3ypS3GXminMWoqP0e/iiwHFaVMEruJZZVWhyn5tSSIJi48nG3k
	 CZb3wppbbj0utqZqkYnR2BhXiLhIV73caS0wgFY1no7ByHQ7fyEkEE3dn+SvQgRjHJZdc
	 YzW2IXPfovT75d2MMql4Twu9sofFK0B1afIulc0rDVvVXuWkTh9AqD5CF+eOnVaROd3PR
	 qZVl3Kfn6d6TJrQKwg0xtHgOJxhnSp2rphUAzBaPXEGa5yKstYFLW1olsotoOzGnLnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522548;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=d9HqcoeNHJyDgz6tOXUr/ILnaf4DmJWp/tpITSQKCxw=;
	b=Yt5q9e7ZV5pcImZ3eIfusdP6752DgSu3ITXEl6ScyXgS1SK77CRA6I5irtKgKQh3QAcS
	 kQGEl4cbGwpz2QY9p9o6kIJJmWjF6MxQfEhJg+SpXA/JqloHZsjHsC8TqQZxWrXjlH6oz
	 Bdz9FeOXMQfAn6lt7PFm0dIKg50WMGpIVmAhyXUT3ZTped+/41lXw4jfgtdo2bCN8cOXU
	 A8+nX65NGZIQ/EpE+raUe2YhqQFthvmnVN2ItNrO/lkIQJYZD2uLBPbFSoV0Xwj1xI0PV
	 OPv89IegYkU8KCpza/cQQUAQnu0otAFDJp6pZldYQOn+zgFKWXREipRH4rMRgD3Krng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezdQW6pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1218606A321;
	Thu, 12 Nov 2026 22:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezdQW6pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F51F000C4;
	Thu, 12 Nov 2026 22:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522548;
	bh=d9HqcoeNHJyDgz6tOXUr/ILnaf4DmJWp/tpITSQKCxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ezdQW6pqcxFMJcYJFFPD9hbeweIh+6jYpHzoEXouApF9tIO6lTRiFLNyNaFFcO9oP
	 f/BIxsHrpBFkP3UjTVFc6KCPv1ei0fmG/bElj3Fg7iQFLETwZRXVffsGbkvgYwy8Mr
	 u407Fr2IrXfW6R5XTjti7rPckeX/mAF/6A7kTSZZu5jVlPE/OCOilDQ8/CkhI74NNc
	 03WcmuI0R+cSwz/IjRhd85nRi9sE36yXUdsGzUOl9LMRjOdkK8JDXHId+CixkjzOOF
	 r0M5RXxl+6IcxZLzWltD8wpCviNk7eO9ZjP3MwUCj7+4ejguyi3HtVJFTpXoeq/ep3
	 fNL3Xo8QV7i/g==
Date: Thu, 12 Nov 2026 16:29:06 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	devicetree@vger.kernel.org, Thi Nguyen <thin@rambus.com>,
	"David S. Miller" <davem@davemloft.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-doc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Message-ID: <179452254555.1729707.16190118012277319671.robh@kernel.org>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>
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
In-Reply-To: <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>


On Tue, 10 Nov 2026 08:52:27 -0800, Alex Ousherovitch wrote:
> Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding describes the parent
> SoC-level node with its SIC register region and one queue@N child
> node per mailbox the host owns, each carrying a reg (mailbox instance
> index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
> rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
> crypto cores are present is discovered from the SIC CORE_ENABLE
> register at probe, not described in the device tree.
> 
> Register the 'rambus' vendor prefix for Rambus Inc.
> 
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
> ---
>  .../bindings/crypto/rambus,cmh-v1030.yaml          | 145 +++++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
>  2 files changed, 147 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

