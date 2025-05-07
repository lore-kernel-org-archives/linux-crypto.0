Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD272635
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 09:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746610356; cv=none; b=byPB53N9FFuMCuZox8Vl8L9k+ETVH7z36nvJeKN04hRb6XH3dOQM6eHhGa8GQATONMEykFTRJZwukkOw3mhA3K+tyj77XFfcpdb1/yY/jPdr/OBdBwhare/FUvrVyho7u+JrrO26NDt4xW5TIOScAtI1YiezcC0vwmUXS937Kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746610356; c=relaxed/simple;
	bh=+dcoGM/MPnQ7gR2bwDmEC4W4glqMT6D4Z27/zHMAu6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=az3iSMnsrsdJzfVmy2a0dsgGWBhX6Fj5r5b0nzqpUUNyCblTbKcCKXcrHyAnx0fx9FU5MdINkXYGjnvvjgkYQr6M8BMSI78Uo8uci8UQUQuAeBrBtci6lBfjVkD77SJR6D00oH06ttgwiHaujBLJ5Jrw0mk6VTICZSy3Pb5r1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XTR6XmVp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTR6XmVp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746610353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89g+uUbAmI4s1rHApPcoGavOskeIK/6Orkxfvy6zQ+0=;
	b=XTR6XmVpWa4wZxSIc0nJI2ItHsT5JkZXjc92gyUPWAJ6ptdKrhEDqFKC/7KHet4l0HxFga
	PlExHDks005c5vYQAfzAZwWplMPwQSGZpKvllUs4wTg2Ep2WnNBVx03OGznWfq45yjVsDB
	jMCULBqfPjV1HnJpiUZCfS7SLvUiBuE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-xfqT6i3wOMmctt1jAxRE5g-1; Wed, 07 May 2025 05:32:32 -0400
X-MC-Unique: xfqT6i3wOMmctt1jAxRE5g-1
X-Mimecast-MFC-AGG-ID: xfqT6i3wOMmctt1jAxRE5g_1746610351
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac37ed2b99fso567813066b.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 02:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746610351; x=1747215151;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89g+uUbAmI4s1rHApPcoGavOskeIK/6Orkxfvy6zQ+0=;
        b=Sqd2Jx3Kdi6kpnW48vm9b6lxneojMuzsH69qroZLCKoh1MdVtci3vj0EB0M78R3GSU
         B0iA9gKHjLGLMCn5lHaQK25LERJ1L8WnlL9XWCvgxm5dqFbl+Gbyt9IApDxq/9shsAR6
         YXBWkP3WZIsjR7v+SmQSXglC82al+9g9twrxwgna6ftRPFX4Kvdts0BHKrEnaloBYyN+
         6pqbkxQFpQj+XPJ8bfa4Th1080eqNEGiIqX114WuipIkuzKrfjhQQT4LkRfgUyqoOh6O
         0SP3Ls7JnIaIBUb4Fr6XidsN0ZrQ9sRreVvThjV1VNrvjNtz1HFHigRmIoYyJSXcGyff
         Hh5A==
X-Forwarded-Encrypted: i=1; AJvYcCVJLeCrJVsGF5jC2Gf3oHe4DizyyG//9CemM9enfzqqgOjIJxyZzLqBmaKDI8jhMFnUqAXvBVK0f04+ytA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzoh7ddtQOtf5oBS/JZCP1FwsS1Ds3SIjv/MakpQ46+5xGqs7bL
	tR1jkFKMZ5qUF6cMs/Aw8olPhjKl5i0bbz+guF/VIJDvVC4EaIFnLDpxTeZ1AI5U7X7KsNfP20D
	NBK6aIrGCshO165OQ9chN5LVV43aMY2o6GpOK0FJvty16ppNAXT9iUOj/D6hgSg==
X-Gm-Gg: ASbGnctYJMjl35FMdxs3ZCWxVNBACcCc+LIR71orGg9XHC760GOhpAE4Sjk6CYJd1LT
	CwbvLCcU6IJ9A6yTf8L5N5OAKk38A9313E90QatAxbizH36FWECdToz3ejeOoELRaG17kgCyIHB
	IUpop2G3sa+yg2aQUcghPE3kDJZ0Ed1KvkktN0136HMgRTTGNd2lJYOozF3ln4XCjPAhg5Yf798
	Uj0UMMgxspTzZI4ZR74X9du0sQjEt5zbHvtsPh4vL11TW2XmIYvFFbHf8rlHmA4RK6NbV2oPDsR
	tptGlrV2oQsy3S/x
X-Received: by 2002:a17:906:d54d:b0:aca:9615:3c90 with SMTP id a640c23a62f3a-ad1e8d0ba2bmr267001066b.52.1746610350921;
        Wed, 07 May 2025 02:32:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFB9GITuMuYoSYN8HyavQFo2/J56H0NB7QS0JaWBQv+IFH3p+ygglDzNeMYFn+SDDKrajLukA==
X-Received: by 2002:a17:906:d54d:b0:aca:9615:3c90 with SMTP id a640c23a62f3a-ad1e8d0ba2bmr266997766b.52.1746610350328;
        Wed, 07 May 2025 02:32:30 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.165.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad189147329sm869562066b.1.2025.05.07.02.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 02:32:29 -0700 (PDT)
Date: Wed, 7 May 2025 11:32:10 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	peterhuewe@gmx.de, jarkko@kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org, jgg@ziepe.ca, 
	linux-integrity@vger.kernel.org, pmenzel@molgen.mpg.de, Yinggang Gu <guyinggang@loongson.cn>, 
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH v9 4/5] tpm: Add a driver for Loongson TPM device
Message-ID: <CAGxU2F6m2=+07sUoy4PKVs1vMR6Yr--pgkOG3SEGg8gi=HRf+g@mail.gmail.com>
References: <20250506031947.11130-1-zhaoqunqin@loongson.cn>
 <20250506031947.11130-5-zhaoqunqin@loongson.cn>
 <2nuadbg5awe6gvagxg7t5ewvxsbmiq4qrcrycvnrmt2etzq2ke@6oyzavctwrma>
 <0b148f09-d20d-b6be-d31b-6c8a553658c9@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b148f09-d20d-b6be-d31b-6c8a553658c9@loongson.cn>

On Wed, 7 May 2025 at 03:35, Qunqin Zhao <zhaoqunqin@loongson.cn> wrote:
>
>
> 在 2025/5/6 下午10:13, Stefano Garzarella 写道:
> > On Tue, May 06, 2025 at 11:19:46AM +0800, Qunqin Zhao wrote:
> >> Loongson Security Engine supports random number generation, hash,
> >> symmetric encryption and asymmetric encryption. Based on these
> >> encryption functions, TPM2 have been implemented in the Loongson
> >> Security Engine firmware. This driver is responsible for copying data
> >> into the memory visible to the firmware and receiving data from the
> >> firmware.
> >>
> >> Co-developed-by: Yinggang Gu <guyinggang@loongson.cn>
> >> Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
> >> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> >> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> >> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> >> ---
> >> v9: "tpm_loongson_driver" --> "tpm_loongson"
> >>    "depends on CRYPTO_DEV_LOONGSON_SE" --> "depends on MFD_LOONGSON_SE"
> >>
> ...
> >> +static int tpm_loongson_recv(struct tpm_chip *chip, u8 *buf, size_t
> >> count)
> >> +{
> >> +    struct loongson_se_engine *tpm_engine =
> >> dev_get_drvdata(&chip->dev);
> >> +    struct tpm_loongson_cmd *cmd_ret = tpm_engine->command_ret;
> >> +
> >> +    memcpy(buf, tpm_engine->data_buffer, cmd_ret->data_len);
> >
> > Should we limit the memcpy to `count`?
> >
> > I mean, can happen that `count` is less than `cmd_ret->data_len`?
>
> Hi, Stefan, thanks for your comment.
>
> Firmware ensures "cmd_ret->data_len" will be less than TPM_BUFSIZE,  so
> this would never happen.

I see, but I meant the opposite, if `count` (size of `buf`) is less than 
`cmd_ret->data_len`.

I mean, should we add something like this:

	if (count < cmd_ret->data_len) {
		return -EIO;
	}

I see we do this in other drivers as well (e.g. crb, ftpm), so I'm 
trying to understand why here is not the case.

Thanks,
Stefano

