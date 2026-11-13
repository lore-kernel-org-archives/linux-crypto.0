Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.42.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794529432;
	b=4lhCpJWiHOS6A0gzkp9WUVr9dMt4Lpc3NxHgr9/tfFUEW46n+zHdvPqPHQrf7pTkXke5
	 aL81gVufsDdcRgkO1bGUEvZuwsKUak2/jcjPq9ajHPJMIBaVaHTQbuY6KAlqyz5nxUT/a
	 45nmmrJdbR/3UAjz/Su4UPV6YQ7qS+68GNmNA6JfTE+M42vx5Fpt8MqnrYj2Uei6Kf1dv
	 z+QJMjY+u/+GADaQg8+G2DBIXz9hLA1Jcwxw0dBu4mz9i1I2uuiVac9XbB6mIlQUhckBn
	 /T5McPveuJ/ow8/CiiBdF5AjWT86OXJE28+vYdHLffL7nxbPCMpGzm876EXpbLgNkzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529432;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=uySeS/3n+f/dnCpiQL/nNK6+E4iD/pjRor5eQt8LbnY=;
	b=w4QWwHInXcK/vqk9logc0LXDs99eJk4orkVN7WJH3x5XNeY0Upy6lZbh+isF9DLkFLax
	 w6IRHFsH5ZyymnOxzq8keCxhYaSIo/v/Agw5OlCV2DBz6QM70utSaG0qifH693hVYC5Ni
	 zMNey3jFybpUZ27Iigx1VvpzjJi44SMDkOJvO7QJuZIUr/wli21CMgmMIbd76i1lJjMLk
	 n2qppAiqzECqrN/kimmX8I+JPxmvJ6bZjJsmqGL+7MYuRV/33D81VSGi384XU6eYaWcuy
	 wLorUEzopCLlzlkw8a6laMTa3zMlRNTszLuj+1R3L0brBKGe79jZw8kad09jx8LFi3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=free.fr;
	spf=pass smtp.mailfrom=free.fr;
	dkim=pass header.d=free.fr header.i=@free.fr header.a=rsa-sha256 header.s=smtp-20201208 header.b=OjYVUbaq;
	arc=none smtp.remote-ip=212.27.42.3
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D379606A31C;
	Fri, 13 Nov 2026 00:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D379606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=free.fr header.i=@free.fr header.a=rsa-sha256 header.s=smtp-20201208 header.b=OjYVUbaq
Received: from L30177.local (unknown [82.65.104.223])
	(Authenticated sender: vjardin@free.fr)
	by smtp3-g21.free.fr (Postfix) with ESMTPSA id AAF0613F88D;
	Fri, 13 Nov 2026 01:23:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1794529423;
	bh=pVXU+tvezYWROo5H00YtuV+H1jOsfuEbNPNc7yBOEno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OjYVUbaqwpsVIWs84XPFSxLn19HuKXqyvjazjzvXsaQ3inXsjimEerMORNEgzZUdU
	 ttkbRUroQsjqnZCzn0mxSGaR6Goa/Wimue7DZaHhrAEOjUQtOQyz3PG0UO1sJIUjgW
	 WlcYkFutGR9wL5MALQnNt7EKTX1PGuTbOBwRuL+NWWd+lUoZgq6Q0QHR0z7o/oUXkZ
	 nFa8/3J3+iC1oWvNGlo73IVPerKTQlHUvVA6Vru/8hvqYEX8kio3xxwoc7tfZDbTnS
	 dyPNg/inK7HX8qYK8COqw/LDW++6apGpAMrI+iBABATjPzL5nZNSN+elHGqgzCPAIw
	 Wgra/likqwKNA==
Date: Fri, 13 Nov 2026 01:23:34 +0100
From: Vincent Jardin <vjardin@free.fr>
To: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] crypto: caam - never share the gcm and skcipher
 descriptors serially
Message-ID: <avZYhjJsa6Ih7nBG@L30177.local>
References: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
 <20261112101440.673231-1-sahil.malhotra@oss.nxp.com>
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
In-Reply-To: <20261112101440.673231-1-sahil.malhotra@oss.nxp.com>

Hi Sahil,

> So this needs to be tested on other platforms before it can go in.
> If you have numbers on other SoCs with fewer DECOs, that would be
> helpful. We can also run it on i.MX boards on our side, if you don't
> have access to other boards.

No, I do not have other CPUs than the LX2160 : your feedbacks with i.MX
is welcomed.

> If the regression shows up, one option is to pick the share mode at
> probe time from CHA_NUM_MS[DECO_NUM]: NEVER only when there is more than
> one DECO, SERIAL otherwise.
 ...
> Do you have similar numbers for authenc and xts, since they use the
> same kind of descriptors?

Since SERIAL vs NEVER impacts the performance depending on the CPU and
on the selected crypto algorithm as you suggest, the code should be more
dynamic, instead of a single option that slows down all the other cases.

How could we keep "selecting" the best one for each case ?

Best regards,
  Vincent
