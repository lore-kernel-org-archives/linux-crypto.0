Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4D91F191E;
	Wed, 11 Dec 2024 11:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733917218; cv=none; b=ghHFKcRkFRtLtJjaDubPB0KH+yCSvcKEysM3ln3hDdIGkrcJ1j5p5xQrY+k5hv6jiQKa5ANuegU8HWD+Qkfy7qi71FAeHnZxazN8Y9mKX5sdGHymolkviPbARnxWHjCR89WswaG1ynVdebSz6fBdP+4iXkeii0eDNFLX12/sG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733917218; c=relaxed/simple;
	bh=VHGL3u0EdA+ohBMKTYCA0Q8nxt8Cql2CiG/tIRN+9OE=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlQPhytARtdHt2x/Y1iV+Ydx3gIHRFuV9gqAECDLVVH/mMZiGo9R9OiVMTYANPnoc9tnJEOgUcW/16dAIxBPO9brmwx5TgqfCXSUNz9ISrl7cupNoCUKA/vAzgVYXmcnbde/XC7fWPrQJMMTAoh4LBJcl+5Q7TNfICodFE02tpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0wQ26Bk; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0wQ26Bk"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso5429819f8f.1;
        Wed, 11 Dec 2024 03:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733917215; x=1734522015; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qlvml2G4Xi5ig1v0QjPfVDw4ozpGhiPCOsava1Ml8Js=;
        b=G0wQ26Bkr30QmoBom3XYFBtnK5pGnHEwGodCoU0KmNUIG71QoIhts55l8RsDNlf2n4
         ZBnhbzNww1oqepNxO9jY95ZtJXltO8OEsF9RbvfqUJh7KaqOQeagmhdXDVIV4/vd7AZi
         Nzc1Pth7ht8vcp/Dv15zT11TQKAL8zRB+V23INop+2wqJw7YYtWQ0OQ3JlblSwfMheaY
         90Lwa4GMXyNAqAdflvGqMs9uG8WVstHQt7n+CyuodHKQWh9p4UJnvKhugQ7N7uWIE+Oy
         4+3lNlN3ittxeoJyzv+lyNHnbT4Umaf9RzRUIcgFRBuBPPfKl9X18oTb3RjTE1lRR2KC
         VlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733917215; x=1734522015;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlvml2G4Xi5ig1v0QjPfVDw4ozpGhiPCOsava1Ml8Js=;
        b=xJXmGzEe7dZoKURDF8Qyiv1Xnli4FFkN0QNkHcsNCtpjiP46aVmO0bM0IJJ5qSEAS1
         v1K0IiEplob9ZzVRW+b5yHCxsDtREiANkw+sRZPSSBl1CCetiO7/bHZAg4NP6ZXZHJgq
         F1PI3Tq55mqJeqXaQ7e877bCvvRZUg2NIGWXKS1sts++X1yNAFuyfSM/kDWj30/Zz5VM
         UtWAwM2wRd54NYi3oiy+7H6vNDR13I+x2Zzq98lUXNSjHirPo9/n3Sa0VfAqCjBzWywb
         LCJ4iVtFP/kQHkf0fmC6z/66aDBT5xP1jp93sH4Nkcd0ldmezVmHx1wlw1NNz76WAtMv
         kX2g==
X-Forwarded-Encrypted: i=1; AJvYcCWj19dDu5WwQ/d0M+6zR5SIutG1tOeWLbqepM1Oa7eG4zkpnRsy6KzQCWeG1ocbN5celIZTlkPyfhceK0qW@vger.kernel.org, AJvYcCWjosWYz8wTIl4mSh5WPZ8QXOkUlcM+IMClP6OOPDOYAlYCjnGEf6hZaxDZGbuKlNGonxHUfCHZXXDz@vger.kernel.org, AJvYcCWwjRcDlSwQQldMaLMXbJQvcNW/MYOCS+Hjkeo5SJj2VfIkzDhIfS9h06FQckmk6W73rE1RbyVPDSTzR4j+@vger.kernel.org
X-Gm-Message-State: AOJu0YyaJlhp1I0SCIyj/jOBCmSZOl1aMKQYou0lfp3gxgCCWDA1qxEH
	LVYOyWaeFLGYvrTWCv2Cr6F4BKLmxWusInUVwRpxV6ji8jrECRjY
X-Gm-Gg: ASbGncsXLAnpImDhqaqW3YBRot6yUsG8MEkxkfviZIQjBtuMP1EsqdvgJSxX48o6haj
	9fbF61s2SMGhPZghVKlQTkPEfCuU0PRk8b0c+F/GKUWUIZB1XWek/63JQiyQGbC/3hBPyH5dq/l
	JzcjkNhhPpibvBZBvw+VLxrFLP8w/0h3YQqAaOlyiPZ0mHvU7cjo7v8LVqT92jCk5H/lkHo+s/6
	0DIBgNoV0+hGYxATbr8wGIU9mmJhFJwuEUac8Ara+IWICQiTvNinENjkQ/Pvifsi5LkA8+usTfz
	mWfoYp9jew==
X-Google-Smtp-Source: AGHT+IFiA1Xf7QFgwYwlmpgBDu0fCeGNMpapKx4zkoOoVFH/jisTnTeHhTBy5KZBO/+3QOQXv20ouQ==
X-Received: by 2002:a5d:6d03:0:b0:385:e4a7:df09 with SMTP id ffacd0b85a97d-3864cec7063mr2403857f8f.44.1733917214360;
        Wed, 11 Dec 2024 03:40:14 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-387824c2bf2sm1079314f8f.55.2024.12.11.03.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 03:40:14 -0800 (PST)
Message-ID: <67597a1e.5d0a0220.9b04.2bef@mx.google.com>
X-Google-Original-Message-ID: <Z1l6GYZY1dHMKb2S@Ansuel-XPS.>
Date: Wed, 11 Dec 2024 12:40:09 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v8 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
 <Z1ldzyPKgoD8GZfx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1ldzyPKgoD8GZfx@gondor.apana.org.au>

On Wed, Dec 11, 2024 at 05:39:27PM +0800, Herbert Xu wrote:
> On Tue, Dec 10, 2024 at 09:48:33PM +0100, Christian Marangi wrote:
> >
> > +static int eip93_hash_export(struct ahash_request *req, void *out)
> > +{
> > +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> > +	struct eip93_hash_export_state *state = out;
> > +
> > +	/* Save the first block in state data */
> > +	if (rctx->len) {
> > +		struct mkt_hash_block *block;
> > +
> > +		block = list_first_entry(&rctx->blocks,
> > +					 struct mkt_hash_block,
> > +					 list);
> > +
> > +		memcpy(state->data, block->data,
> > +		       SHA256_BLOCK_SIZE - rctx->left_last);
> > +	}
> > +
> > +	eip93_hash_export_sa_state(req, state);
> > +
> > +	eip93_hash_free_data_blocks(req);
> > +	eip93_hash_free_sa_state(req);
> > +	eip93_hash_free_sa_record(req);
> 
> The export function should be idempotent so it shouldn't be freeing
> anything.
> 
> In fact this indicates a bigger problem with how DMA is being used
> in the driver.  You shouldn't be leaving DMA memory mapped after
> the init (or update) function completes.  It is perfectly legal
> for a user to call init and then abandon the request by freeing it
> directly without ever calling final.  In that case you will be
> leaking the DMA mappings.
> 
> So make sure that DMA is mapped only when needed, and freed before
> you call the user callback.
> 
> The import/export functions should only be touching kernel memory,
> not DMA.
> 

Just to make sure, this is only limited to DMA or it's also problematic
to the block list? Aka NO FREE should be done in export or NO DMA FREE
should be done in export?

-- 
	Ansuel
