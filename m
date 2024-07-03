Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042CE17B50A;
	Wed,  3 Jul 2024 11:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006004; cv=none; b=oePtXoB0rXsyhHNda8n6ClJq5iNykn2NblHfPCCRbd1c3BwMGufwcZHJdLe1f1bUQDYs8jBiYT8kQGxMqs3scjDyknjsEZFeqRT89r78sRjobVNKmkCXvRjvl3vguIqs+5acBho4HIeD+IF4CEOvR2JYBW/TueCdwoWnANpQMHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006004; c=relaxed/simple;
	bh=NAwTmEHqJI/g5QC50U8AQivwoiPQ/FxFK+E4TqhVNPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fqi2sqIq0HBAj9Zp0Cf1etfHQc73EC/GVg4za4SwiYy9hh4cNJ0PxUzzqxOsbAdqz6nU52Gau/3CvupsiP2u5Ennh+vCUaYMgIXb4VpHTpPsP7ywWVne8tjQ0iUfEhFbBTeE87dg2L3CYtZ1hvbIN7+4S+pZBNysvcfFVmJxqjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52e7693c369so7174202e87.3;
        Wed, 03 Jul 2024 04:26:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720006001; x=1720610801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6Pb8eWYjG/lUAtf/dpDbWcNlsXUZ5c2rnoW11IR3JM=;
        b=wbctDzPIt4JNpmEypYhvsTnMZt5SNSG50iLYdX24tr1Vs+tE55AqzDS60igJ8NGmD/
         doCILuyAzXov32Y+Xctfhs/Cq8V8TXSKym4snvL395Dp/AxO3XtD6BRRtTpI5idr01UI
         e+gGx9hil4iS3Jv9ZhMSAYoMqEfpM4uSfEv52HeQnNZTgaqcO2Fo8NSw7e6VadkDdxll
         zXtl6YP25Pa3AJgzLuH83zlZ1EC3zt/e2MI6JbjAFyWB8O9VJq3ErcsH/tObJXypFYPi
         Jwfgf3b8gAibnoXdzHWRYpQfWthoprLmk0Dz39m8bxIph34EMk3XjGtVbnAd92p4e6XU
         wBlg==
X-Forwarded-Encrypted: i=1; AJvYcCVVdXboL1NZjCcg//+LAlixOHSTC+j25xKlTsdKHYMKKkLnCXzoey8CeYCR6DC1J9A8/nU7/4BSQa6BTQ4uEL3+pMtJtnXZC7Ml7crDFBUSGG15F6a43LxiW9/mxsWa+hTbPbFeq8dCYlPR8DUz+FH1Fy9Z4ES/D9MknwGyohWClkBk
X-Gm-Message-State: AOJu0Yy74Wj8SkFIbaKQKmG7FQ+qU+Wc8NzGZHIJhT8CKhRCaV8yVNsh
	qe/a7qHODPTayBCpui0+feWoNX0Bc//AF//E0CE3/BuOJ29ceY2t2LGNAg==
X-Google-Smtp-Source: AGHT+IEbAQ8nFW0BsPbyiOwXt/vQdxbqW/1IV4VaU6x/l7d9vtN8XdicV2zAwUK37aIl/GyFuMd2lA==
X-Received: by 2002:a05:6512:3b91:b0:52e:7f87:4e66 with SMTP id 2adb3069b0e04-52e826ee70amr8624122e87.49.1720006000901;
        Wed, 03 Jul 2024 04:26:40 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-005.fbsv.net. [2a03:2880:30ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58612c8368esm6843735a12.19.2024.07.03.04.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 04:26:40 -0700 (PDT)
Date: Wed, 3 Jul 2024 04:26:38 -0700
From: Breno Leitao <leitao@debian.org>
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: "kuba@kernel.org" <kuba@kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"horms@kernel.org" <horms@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next v3 4/4] crypto: caam: Unembed net_dev
 structure in dpaa2
Message-ID: <ZoU1bh79jugMaRty@gmail.com>
References: <20240702185557.3699991-1-leitao@debian.org>
 <20240702185557.3699991-5-leitao@debian.org>
 <AM0PR04MB600485850F153B6792CA8C0DE7DD2@AM0PR04MB6004.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB600485850F153B6792CA8C0DE7DD2@AM0PR04MB6004.eurprd04.prod.outlook.com>

Hello Gaurav,

On Wed, Jul 03, 2024 at 05:45:23AM +0000, Gaurav Jain wrote:

> > @@ -5096,15 +5109,23 @@ static int __cold dpaa2_dpseci_setup(struct
> > fsl_mc_device *ls_dev)
> >                         priv->rx_queue_attr[j].fqid,
> >                         priv->tx_queue_attr[j].fqid);
> >
> > -               ppriv->net_dev.dev = *dev;
> > -               INIT_LIST_HEAD(&ppriv->net_dev.napi_list);

> napi_list is not needed anymore? There is no mention in commit.

Good question. This allocation is now done in the alloc_netdev_dummy()
path. This is the code path:

alloc_netdev_dummy()->alloc_netdev()->alloc_netdev_mqs() which calls:

	INIT_LIST_HEAD(&dev->napi_list);

So, napi_list is initialized when the net_device interface is allocated.
