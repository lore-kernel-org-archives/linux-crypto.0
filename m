Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3872C325B
	for <linux-crypto@vger.kernel.org>; Thu,  3 Jul 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582830; cv=none; b=nmeZ6qgPNQmHdfiwIuUk9xQeF//Sl89xFDXGsqw/1eNmpa/Wklp5vAvu1IwtVofbU2zY0iIjE5yE3O73tUfGFoWDCpaNp1o1XEfrM77/pTPIVQPCK0Nze7+m30inxQYcX3XmZ/AxoDnw6vLEw4eG/A0xW2B+g7K+ykqBBmDiBGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582830; c=relaxed/simple;
	bh=DSNEbePw/wOeNUq2xUCLQ1pB/OY0aOxgKSwxCOYMEyk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=E4WZbqG7mXqZ0nNlEYYBHvc3306CRrJ+o3G8Yc7AkkIsELqp/Xbk/R1LADOPbObbFl//MS1EmGxaSumbPz1tIqj1lCpEd6Rsp0H+Wp0iGAX8hfthEISGXtnjOyXIS3rr+ttrZw/fkXWYzgGhB8XdlMLoRv++0Uvri+kxZ2AsN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P+cRfvDL; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P+cRfvDL"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751582815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DSNEbePw/wOeNUq2xUCLQ1pB/OY0aOxgKSwxCOYMEyk=;
	b=P+cRfvDLupgeT4JgtUg3U1cRMw2ljYea7E1fphtBvveFfsovi6RSEGeW9kdDcNe5CfORjH
	wpWp79rRbq2DCEUf+i5peSKEw3DBPZ9YlMJzH5CWoryhldmIHracidQOtiKdYlP1Rf9a/d
	JDUKi/WlDcaa0c+YoIZcR5nZKsOGXtg=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] crypto: zstd - replace zero-length array with flexible
 array member
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <202507031448.C3DAD52@keescook>
Date: Fri, 4 Jul 2025 00:46:42 +0200
Cc: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 linux-hardening@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1ED66B1B-339B-4C86-AA04-36E1345E0A02@linux.dev>
References: <20250703171933.253654-2-thorsten.blum@linux.dev>
 <202507031448.C3DAD52@keescook>
To: Kees Cook <kees@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 3. Jul 2025, at 23:57, Kees Cook wrote:
> And likely, to use __counted_by(wksp_size)

I hesitated because semantically "size" isn't a "count" although the
values are the same here.

> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks!

