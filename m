Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3323909C
	for <linux-crypto@vger.kernel.org>; Sun,  3 May 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777778710; cv=none; b=IT6KWIoO2unfYs4571pnfcOuXe9UD+nzgVt85EkDMFneSEMU1jho33X/2uPbdL1RDj/ppDA8gT6bejhn86/X31eD5kunmqABS2vKD9aBMVoymLbLcvQ22nj63JsTdyhYaWl2u3jggG3iJB/fd8r+N8TORV1RF87H4PI4IVAIChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777778710; c=relaxed/simple;
	bh=j+YKrJqTLc01w3t5RXJxjJCQDUwvXRBgKrtglbtP8sA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=CedyVS4CGxxLL5HrAfHyoAy4are496mGGItCTRRfnyPDh7+T35Pgpp0HYzHskjchAm3WAdQngeMez/bPVDyY6FQf2XZ5UJlyNfpB8b+Y6Sk/GRGBcNQdjbECyHPzN9W0AbB8UbOhfj33PYMDVvd66YXm1M8k7XSKRaOobIao8/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7apRkvq; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7apRkvq"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-47c941f6bdcso373107b6e.3
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 20:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777778708; x=1778383508; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCiCsyrBlQrwiRaDfwl6t7fLLvkn12WS+YilO87CwYI=;
        b=F7apRkvqmm45V+9THsQufjQ/JLTlGh5HtlOY0sTpjxg5pZkqeAGBdNnGqZbyP+BGkr
         aZlkYjV95zSsvDgX/OncFwzfjgE8IT7LGBfGxebzJy8xcMtl0Ft57UPMc3OjKCuDpfkK
         7NRJEC3MebVxbaQVT9ioK2La26hlrrwJvTrcatb2rE9rlhTG/gqt0QRd4wzhz0KTMWfX
         ngeVgoT9xQ6h5M9joFXB/dqEBd+efP4DzUGuAuc9u9FLLvTfQhmJmJkkXsHNP5w2+Gir
         exe+mnXtnO7qmR/jODtZnKjngKVKP+ywqOaT7vzYjVBYQAue947EI62P5Cpp3JTQU2eD
         2SPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777778708; x=1778383508;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zCiCsyrBlQrwiRaDfwl6t7fLLvkn12WS+YilO87CwYI=;
        b=E4jd1mV6HbFnUC9Cw3zqAIUUFLd/Wp7ZFQHauopAKg+oxO/KFYXV4XN3UhUe7MndCr
         2Gx0p7sYNZ8USo5HWxGtwMlBDA9YgP2Ffqp/VIyPeZB7dfbZs49nl5C+BMmWbvdgmWUT
         SC2zsc0FsXukkuPByFrQ52tNczmuqRzJ18NXebTNf4EWefabzQgIl5s9xkutCREEZpP/
         k8QsOKHin6PR1OiFEHvNbSo38zqfWx4H9bPy3S/ySLWoEiB6MmgVLMnkgvHAcN4T0MEc
         DNTp/qvvIV1rQfr3+cNW+gObplz9f0XXYJIonsmHSJO1tBdJA4b0Na8j2+aH8Wrtm8oP
         QK+Q==
X-Gm-Message-State: AOJu0Yzd7FAWExoPXZYYrSzhov9BQpTU6ulnTLDszqOMGKGPhGtLNxRB
	0Ecg8ZzG+/CSIIS54rCm1UfhAXD0F67S6TucjT1cE7AC1A+ECV2bwqCf
X-Gm-Gg: AeBDieshp3Dl7UbR1baGXs4Xt2LZSVx8akzltt7Re5uVvP9gtqngHotiMq8jVBLo4u3
	ttrBFeSCJxxxd6KfCYAVwOyfTj+mFWVBEIYGl0cINV4RDmabx9n80xVFwMXFqU4O23ZY5oLd2G4
	pqhlb3TUmPY22Eg/avFawoockWFRZElP8eZfb0K4BIDm+OzERxYuy66fU81etS74VZFaMPzlThO
	CVJnU3/k1LAJWKE97faMjjPq21pNarEectqf2/XcU8xKKfwjAZsNsdbJyka5WVaZWYcfM7d669I
	gBm5j7nUbYg1w27aTnz3n25t3fb+jZZIuZ7lCkHv9gMgko4QHNMknhxaiSfY/7bCftzwY+NEAml
	lKOKAAsI0T1PDvJd+BGUYy3nfPJZbPZBrWl/mXdGnza6QbYqVeXHDR0ve47dFPBDDMu6ONYrdAA
	saTGWb0vcAPTDzgk2tns13ImMiLQqT0VEwj/APmS/5oguNFqLxLYsl9YZ2ElJ+
X-Received: by 2002:a05:6808:22a9:b0:467:880:7454 with SMTP id 5614622812f47-47c89081f94mr2858866b6e.18.1777778707977;
        Sat, 02 May 2026 20:25:07 -0700 (PDT)
Received: from localhost (23-88-128-2.fttp.usinternet.com. [23.88.128.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c763b33c1sm4237516b6e.1.2026.05.02.20.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 20:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 May 2026 22:25:06 -0500
Message-Id: <DI8PYF5IDELH.2NUS4S9E01U6O@gmail.com>
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Sean
 Christopherson" <seanjc@google.com>, "Kim Phillips" <kim.phillips@amd.com>,
 "Alexey Kardashevskiy" <aik@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>,
 "Pratik R. Sampat" <prsampat@amd.com>, "Michael Roth"
 <michael.roth@amd.com>
Subject: Re: [RFC v1 6/6] crypto/ccp: Implement SNP firmware live update
From: "Maxwell Doose" <m32285159@gmail.com>
To: "Maxwell Doose" <m32285159@gmail.com>, "Tycho Andersen"
 <tycho@kernel.org>, "Ashish Kalra" <ashish.kalra@amd.com>, "Tom Lendacky"
 <thomas.lendacky@amd.com>, "John Allen" <john.allen@amd.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260430160716.1120553-1-tycho@kernel.org>
 <20260430160716.1120553-7-tycho@kernel.org>
 <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com>
In-Reply-To: <DI8PTIGP3I43.JOF10O9FPOMF@gmail.com>

On Sat May 2, 2026 at 10:18 PM CDT, Maxwell Doose wrote:
> On Thu Apr 30, 2026 at 11:07 AM CDT, Tycho Andersen wrote:
>> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
>>
>> Put all the previous primitives together to implement SNP firmware
>> live update via DOWNLOAD_FIRMWARE_EX.
>>
>
> [snip]
>
>>
>> [1]: https://lore.kernel.org/lkml/20241112232253.3379178-7-dionnaglaze@g=
oogle.com/
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 244 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 243 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index b4711bf823e8..e7fe6dbf69c2 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> +static int sev_download_firmware_ex(struct sev_device *sev, const u8 *d=
ata,
>> +				    u32 size)
>> +{
>> +	struct sev_data_download_firmware_ex sev_data =3D {0};
>> +	int ret, error =3D 0, order;
>>
>
> Why not assign across multiple lines? How about something like:
>
> int ret, order;
> int error =3D 0;
>
> or:
>
> int ret;
> int order;
> int error =3D 0;
>
> Would be better for readability and git blame.
>
>>  static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_uplo=
ad,
>>  					      const u8 *data, u32 offset,
>>  					      u32 size, u32 *written)
>> {
>>
>
> [snip]
>
>>
>> +	old_major =3D sev->api_major;
>> +	old_minor =3D sev->api_minor;
>> +	old_build =3D sev->build;
>> +
>> +	mutex_lock(&sev_cmd_mutex);
>>
>
> Why not guard(mutex)()? You used it earlier in
> sev_firmware_reinit_if_shutdown().
>
>>
>> +	*written =3D size;
>> +	ret =3D FW_UPLOAD_ERR_NONE;
>> +
>> +unlock:
>> +	mutex_unlock(&sev_cmd_mutex);
>>
>
> See above comment.
>
> best regards,
> maxwell

Also, forgot to mention:
>> static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_uploa=
d,
 					      const u8 *data, u32 offset,
 					      u32 size, u32 *written)
>> {
>> -	return FW_UPLOAD_ERR_BUSY;
>> +	struct sev_device *sev =3D fw_upload->dd_handle;
>> +	u8 old_major, old_minor, old_build;
>> +	int rc, error =3D 0;
>>

Forgot to mention this, but probably should make it:

int rc;
int error =3D 0;

best regards,
maxwell
