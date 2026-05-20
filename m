Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785062EB5A1
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779293043; cv=none; b=Y+ljYovBr++/LpVWroW7hNOWfCF/WxlHPXPeFxlAxDF7xgXp/QSkeeDsCxGXqpvBtsZuf+OF+7FxG36DINngrGLcv5dUsRVc1YTCqqdNE1z5rUgJvsLaKtqBtT9Hcsvugkyzx/0cyz+3P5I1wiWy7qqnhaUhf9mMS8tJuqTv7QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779293043; c=relaxed/simple;
	bh=8BJo9zRAZpaGNwZwW+ofllOZFn0A8UbX7ZrlQ5vEplU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIJBcpIoCGNIKniF2QOSQFncvBxh2Fu7k6VECgnc0Qdg6fi27wVvT8bxOrvs0baZ5qb38gm6dWwKTvVg4WI2Hmms9n3FmJovQmZiTQeBazbCxaraBQR3lr3desLowrDeeikO2gLvoOt0GDj0SPxQeIBTfMwNMJ8+jMn87yNWA1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkVl24/o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkVl24/o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779293041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8BJo9zRAZpaGNwZwW+ofllOZFn0A8UbX7ZrlQ5vEplU=;
	b=XkVl24/oKp66roKJx/P7WXG6cK8k32CNM5FW7PjvfBtfDq5tBXt6+LZHmck5gUz1DWDL7K
	wGBOqNhqp1JP7ScHbxX2dfKtcARCoG3878R6hqsNMgTucvY+ZbTmrt6R3slkbkOhCz1rMu
	hZgdxPazeHqmrHtbdT2o+RcTAfE9UUs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-kBg-HvdYPT6apdPg3FngUw-1; Wed,
 20 May 2026 12:03:55 -0400
X-MC-Unique: kBg-HvdYPT6apdPg3FngUw-1
X-Mimecast-MFC-AGG-ID: kBg-HvdYPT6apdPg3FngUw_1779293034
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C831E19560B8;
	Wed, 20 May 2026 16:03:54 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B80071800465;
	Wed, 20 May 2026 16:03:52 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: herbert@gondor.apana.org.au
Cc: akhilrajeev@nvidia.com,
	linux-crypto@vger.kernel.org,
	ptalbert@redhat.com,
	vdronov@redhat.com
Subject: Re: [PATCH] crypto: tegra - Fix dma_free_coherent size error
Date: Wed, 20 May 2026 18:03:37 +0200
Message-ID: <20260520160337.29100-1-vdronov@redhat.com>
In-Reply-To: <agvleqNqloWB6tpf@gondor.apana.org.au>
References: <agvleqNqloWB6tpf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi, Herbert, thanks!
With the subsequent ENOMEM fix please feel free to use my:

Reviewed-by: Vladislav Dronov <vdronov@redhat.com>

Best regards,
Vladislav Dronov

