Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352774;
	b=AAdqy6SXRfb7rS8OTC4Z04LIp6Rqd8f38LseEdRB1X8xaYmAbQbwmQgEVQX8oMv5EM3p
	 xW8q7PeEsJX5QU0Y9JRgKnKqi2NWs1S/2lSAnT3tokKBUAuIijpbQOcIkP1zsebUcSSe8
	 YrnFls15TUS8ei3nbCkazF2LQMs16Xs+5xTu2DMRDtLUSXXO6texPqYF+nVTJeTF7Ehv8
	 6hLe+9jUS4AFroJCB+UwxcIAJvnHFiR+gq54bGqjlYNTAPzoon0+wf3gT/lyib4B1fpWV
	 s2xPlB8k8FYEX1EtWbOMVrY2j+maSxfOHw0YEc5aUtuBOZR5JBrJ7FhHDLPBfjMkw1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352774;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=mq5a6HvNSQ2FOlYRly4xHcCl+VsY+FjouUWkr2zVu1o=;
	b=O1wy+Jpk3DLaJ5mivZc69mw5DjVKiHEal2mUB14sZlUoDteiMS2QzjrcwJh+Rnwl9pwL
	 SXakWg5jpEzwTecEX/onoHIOLGiuWYdDBNT1J0z3ei4mfPyrnYXnGgFmVU6ICKuQiRCL4
	 pFDV1ISeGIgK/u2h8arvxioq8WPGdJBNdGAfanbfg3teroq5mN7uMIaHlfGQYFlZfyGev
	 dmWFWH7LOb+AxCcZ4qZgxZMPOyNURlAmaB4tTUUNkFm6nRkQZr1N6nP1I7+h/0ds2rFxX
	 mbVAq1JEFaKobZqL3sX5UXgacCKP56bUT/3xnH6xWCOP3q4PnTfdfaJtRhPfNzPGIoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jxQc0pZ6;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9C7606A325;
	Tue, 10 Nov 2026 23:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D9C7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jxQc0pZ6
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.lan (unknown [52.177.6.131])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2255920B7168;
	Tue, 10 Nov 2026 15:19:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2255920B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794352771;
	bh=mq5a6HvNSQ2FOlYRly4xHcCl+VsY+FjouUWkr2zVu1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxQc0pZ6MqLJSfxuWIv/k7tMJUSXpfbBeakPPtn5l+CPik3yPiFShIDAIeVt06j9C
	 EXZmSeavkAlBVbIH9jNVydxVG3BQk+AEp/W0BetabDgYLdKzgGhEc3RukAmFFmPU4A
	 tr76UzOgMkXeALD11aUTwjsJOI/rWHc1S+ghK6X0=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Tue, 10 Nov 2026 18:19:23 -0500
Message-ID: <20261110231923.165037-1-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
References: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Gentle ping on this RFC.

I would appreciate any feedback on the DMA mapping approach, particularly whether a single DMA_BIDIRECTIONAL mapping is the right model for the exact source/destination alias case.

Thanks,
Jeff
