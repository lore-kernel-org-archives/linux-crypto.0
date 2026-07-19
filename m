Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6A21FF2E
	for <linux-crypto@vger.kernel.org>; Sun, 19 Jul 2026 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784483205; cv=none; b=qkgmTw0fnNwVznHr5RNuq5RokOlNl3Kc6Tgum71K8Qk+he4/HftmDbWauuhokoBuYYbOvCyQTToVdR0wnralglYwkX3TMtcMZronyb60ng32S+742lJmff0sQi85Y1tvYEFye9PveNOdQHFezcFbwCHn8QxnjhvOQV9cKDocot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784483205; c=relaxed/simple;
	bh=DOIXaoEFYLavHuWOZwuOq81SQbLBhX8+3kIFqB5iqnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=s/19JkrRwfG970z5sV+5pEIZFAifmctlL6QisMcc54I1GDC/oHRQHlOf5wHj/k3ChTTjscmmf0ehvmvg4pQ7OY8sp8/CbdsvIwtYRex8M5WV3/84MCsYw2MVctUr2h3+z3N7JgFHEKRphzcd/o4HYIOQFYb9cJIYX5J9FIzEcW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWDIFAAT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWDIFAAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784483203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOIXaoEFYLavHuWOZwuOq81SQbLBhX8+3kIFqB5iqnc=;
	b=UWDIFAAT3m9/aXjFwdDNlZdnR0SlUWo0plHh6ofjxuFjAEzy6O+n0UWNU7jzPHx70k7SCE
	TAyczOPco9taj8SiqDoizkaLaeekqY2p/n6bHwwznYXIFKIHfwnvxUhPPgJuwIszFmwkT5
	C9RdIwcvGQgFdtuhIN43NsEwBrX0OqU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-rUAdgQ2iOLaH1aq-GoJIug-1; Sun,
 19 Jul 2026 13:46:39 -0400
X-MC-Unique: rUAdgQ2iOLaH1aq-GoJIug-1
X-Mimecast-MFC-AGG-ID: rUAdgQ2iOLaH1aq-GoJIug_1784483198
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3A86195608D;
	Sun, 19 Jul 2026 17:46:37 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.24.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2541C30002D6;
	Sun, 19 Jul 2026 17:46:33 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdronov@redhat.com
Subject: Re: [PATCH] crypto: tegra - fix rctx->cryptlen in tegra_gcm_do_one_req()
Date: Sun, 19 Jul 2026 19:46:18 +0200
Message-ID: <20260719174618.17483-1-vdronov@redhat.com>
In-Reply-To: <20260719171302.15078-1-vdronov@redhat.com>
References: <20260719171302.15078-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Ahem, missed the fixes: tag, could you please append:

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")

