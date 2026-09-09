Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5273E1208;
	Wed,  9 Sep 2026 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788946092; cv=fail; b=NmrUihgTU+PI+lbBkYkG+zvfwLkwtV3DqaBoB3OAjx47ii8CHlOEvRds3bAvSvPBuKXZSiphM6BfOTo3R9JonQoty5VYSUO5ru96b5MhTGnZCn8eF1V+OsMvX4WcT2y/X7wv3t7GP1FDq922dkOqrbjQqYBcF636IerHObY4OiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788946092; c=relaxed/simple;
	bh=6eNjxs3KOzJoZoIUGwceon382z0O21YdWzh50vJaza8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GQVJNtNdZ2mSNdqYaVc1MhzqhOgfopspBGnIZQAdxKLlW7wKn4yY4wpcfk+XBpJyhVkh4QWzIxNMeIzzkTyuOEK7o/E3jVVO7SNx/my1DDTnYgLui8YWaHrxPUBEitpyVgKbMLfCypE6d37Mh4CLb7CGR2fhh6vQ1rPvyxpcihk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jewK0qZR; arc=fail smtp.client-ip=40.107.209.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jewK0qZR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CClp8yixucsrIV4N/xPiodX1XX2aLm7RH+guO2BL7oyXuOPQIU1ki2ZIgZCm1oY2V7mOjmODQKsa/cQK8NVhJdfKe1d3xy1xv9l6IK11Vwddtu4R2e4LwOtHZHtcPKLj7tpV+LRNCtLyxbZep3msUOnATfpMgu5dcKOxt/30KsIWbSSM8jKVJxGYQyJCKbOKvnU6m/sdI1pDTVFZaztfS4/ncd3F3AueeXBwfMtGugHXw0HjmdNfsiGAAxSoQAc/+vHmFxspWc9aQxczr4/uncspkJH0Ah34N1+Ej6bUDtI7eANpUnLbp6GFHYB0kvrqw1/obtZKNjmOIp5G5ZJHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGcV3coEg4qom7QFXOrFmCRTQsZCRTTvt8QXr1gMg5M=;
 b=bnalmuj+mm0wP4b8+UhJedB/xY7aCfYbGlOz7nEZ3CnEGEl0Uli9rY8fHSNp2l/EMMURIOt/070uisH7+KHpJHBtNbY9hTK2apuho1kWBU0bBR6Zdx/rusyV9ClISHstHul72cjlKpaEmIlafpWYvbtfv5WW9jikSV0H0IJSY46X2I/rPPn5byyTZNP+CM4CYGWUhHcY3XGd/ofZOKmAf/kAp/aEmRS3EEK+ZtYHpfP1uCjCihloCcSFin6jDsImQ3XQIYN+eBsAKpndtJy4LqH8X+hupJS3Kp1Zh27voUjlg6P5yrn5Tq5IN+ecZ6QobNge27sMAtG3ih43SIU4NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGcV3coEg4qom7QFXOrFmCRTQsZCRTTvt8QXr1gMg5M=;
 b=jewK0qZRn6DVpLrzLZ1EtpLCWsOc1TtNch9mkKyFusb6e4lXeD4AwRM4/J3wSOdLMqP2FvcDZ3KyR9ZTbAX35lJpYfjiWgSdIRPlUW7ns4pcCW4VG8CCfP4Ps6SEGp6uLxhJPOTnuJ84yljFz1gd5wzNYAeuyeaEk7ptKI9vysk=
Received: from DS7PR12MB9549.namprd12.prod.outlook.com (2603:10b6:8:24e::7) by
 CH3PR12MB8332.namprd12.prod.outlook.com (2603:10b6:610:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 09:27:57 +0000
Received: from DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6]) by DS7PR12MB9549.namprd12.prod.outlook.com
 ([fe80::bace:1330:9ab2:acc6%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 09:27:57 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Thorsten Blum <blum@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, "Simek, Michal"
	<michal.simek@amd.com>,
	=?iso-8859-1?Q?Uwe_Kleine-K=F6nig_=28The_Capable_Hub=29?=
	<u.kleine-koenig@baylibre.com>, Danilo Krummrich <dakr@kernel.org>, Takashi
 Sakamoto <o-takashi@sakamocchi.jp>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: xilinx - use kfree_sensitive() in cleanup paths
Thread-Topic: [PATCH] crypto: xilinx - use kfree_sensitive() in cleanup paths
Thread-Index: AQHdP8RKUx3fE5nF40K+eDw6Pqwf5LbF+yoA
Date: Wed, 9 Sep 2026 09:27:57 +0000
Message-ID:
 <DS7PR12MB9549DD2EFA3B199CE0F6523F97B02@DS7PR12MB9549.namprd12.prod.outlook.com>
References: <20260908190002.403337-2-blum@kernel.org>
In-Reply-To: <20260908190002.403337-2-blum@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Enabled=True;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SetDate=2026-09-09T09:26:52.0000000Z;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Name=AMD
 General
 v26;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_ContentBits=3;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR12MB9549:EE_|CH3PR12MB8332:EE_
x-ms-office365-filtering-correlation-id: eb44296a-dac6-4f57-5501-08df0e54a268
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|22082099003|18002099003|5023799004|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info:
 Azag9HrePlA0+hMToTh/+3y4r9KhhXQ9rnJaxbVWbsLvSuKXiivXUGa1nD4TFmXlzdTgZZHY4J8yQSJADg9eXqNpTEbP/wJSOO15fBfEYPbtHg1R0vDAAYrLg+xlhJQtN9mRmjwxysQtjMKBSgjwm41it9uGblWQ+axz509zPyE/D+FQ8+hqBk3/zzfZ04V/PiJn6WlOZtDMCMpq4c/jPDPzxeTq/yoBbcprMPdDZADDAO/kTEL99JHtMLf+4dIMM/aJL/Q4fWeOGgOGuAfv0nZFKsHH8YwLuWfFphbszh8Bs3tOicObWtgDPT7I2u3Rm85Mejl3yoWssDeInYGUJHsELIaxEXYs4DhK6rqjUHl3l4sRu74Ec0/Cqsg5rf5uPAwbChCwl2+L+KfkMih9N4LZntzO4znS7oeld9eYLYBELObIkWRsAEbIyyQqTtBDALcVdTqhRkz0c/3qagmvTI6MRoeFRTH7ZTPCje69eRLdD4spkbuZ5WJWBaOZi6EBw7k9hL++a6vWCofwp6gKUiHJkQzWZrbOOljSlNrVonhh0ke4/pqQJVNJJk2wpfg0SaWOtv9Wk/J7YLQWunq56kQJaUP7QlAG8JCdCYfqWlUJ8UKYoCw8W9lSAfB0sLK+at9Uw7XB1A48jpAkBNMxHADoK/MOsMJ7GmI1kOlhxIodB+1yzD73tTAZRTBAPZQDWce4rMe+QlhchU57kuon6YJ0V/Xgborldx+XLZRnWrU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?mfOFyzgnUMKfNmqBsncEjdmeP1iuOQ8ZGkoKdVDWLgrSVwYIVDbWf9SFWd?=
 =?iso-8859-1?Q?qDxX7GQ/RArqwQRYIUMfINx4OohZkFtCK2PSKRO6+ZhJCm/k40I9zK0FGt?=
 =?iso-8859-1?Q?+RtM0EWS6GCggUOa/AQ2umaUJntC/6bDZFzCBMzOwicA4vJbECny/C+OXO?=
 =?iso-8859-1?Q?qSZHrru1yAckSqlwJ5vzHlDg7+B0U1h3Y5957LQfnzaokVdsdqtQeqCmty?=
 =?iso-8859-1?Q?9tBb5ZHL475E0PJkFsfwWbUxqULU79Lf3k15XzfJnO9GyYzHT2kh01lXzc?=
 =?iso-8859-1?Q?gIMMlLj0geL8POzHZ/6vWvIXrCfJ343bWn19Ou9a17FUYyrUqL5TMazsUv?=
 =?iso-8859-1?Q?2wa6vPTEKPy55XZgs6/t5AwQ/dcpMkFlLA8E4qnqHyvF2KuM7YU1byyKE/?=
 =?iso-8859-1?Q?vVWa7ReUttjuz4ll22gVKYnRqvrPuovyVTa+Pq/tl8ixEF/fpqSjtdozWs?=
 =?iso-8859-1?Q?BW3j6qXhwMjKQXvmQZkpvfluwt+EWR6YqwHbZ4veBprrmrbkuCDG+waJ6Q?=
 =?iso-8859-1?Q?g/K3/tN00v0mYcxKho5dLQKPPUKtNwvCUZ/vScCCED670jNmbsMBVQ93pj?=
 =?iso-8859-1?Q?zh5n0wbWocH9upNKMAe3+L5NHur96EC9XiBNJPXFuvKvC/0VEzABFGJIln?=
 =?iso-8859-1?Q?zuTKLZKFqj+umPp86MC7lqKB5dnKsiq92rXsalU3MvRLha8MCasP27uLef?=
 =?iso-8859-1?Q?BEHFgotYiXiF+0jHNTh3+MvcvAfZ14cR5ofBqotAI97cru2HuQOHEsA5rr?=
 =?iso-8859-1?Q?m0PHjpbsTE9lF+yl6F7CvqUgGQLIXZkpxquBnjTm3Ao+N4GiAPFShXqCmI?=
 =?iso-8859-1?Q?qjkuGo7MetCCWD2HCSDyfQuRVe+v/93/kc/N63XrhuAhXoftzRUGzQwl1N?=
 =?iso-8859-1?Q?gIWgmUoCu6/X2+fssHugn/Ld8KXMHkKEpmq/seukcxK+xQpfYFhercibW4?=
 =?iso-8859-1?Q?e8m1rfYnxN7xbM6gvyPnvwZUiOOOLjlDTA0CktmrcGk748DVA5T2PHzFYF?=
 =?iso-8859-1?Q?8VAILPOjhGMtcFaEj1DbIlbvr5Z5GlAD0/zkm7+vJ1J6fYyv2dFtbg4vye?=
 =?iso-8859-1?Q?TC5yYHNeidKSkJdekkJxSgeWqw1R4GV2iiuULiq5O8T9zQhrjOW486aFjr?=
 =?iso-8859-1?Q?qGzzFjRmSzmtI3T7i7uynmVLxxKOl0jOmjCIxR9iWmJ+L+rGk6xrv9uS1G?=
 =?iso-8859-1?Q?lWtEIn4b60878WqKcOwjJFvX80BIDEk6yhpWVXnDxksiIYGq9Rk8hbIWEA?=
 =?iso-8859-1?Q?AIcGX8aG2nlGw+wTM7q5pPmx2GOGn0/Hf7KZdq/jKrcJs038fFztOfNB1z?=
 =?iso-8859-1?Q?5WxoK4tf47CRF8JBXugT3gkGSIFiZwO8fHJBmftZJwVy8ARFtvIrTdE9Qd?=
 =?iso-8859-1?Q?EuI0YAvz0u507eTVcs+hsNUSAreEhp/k7NWlO2LSgiqTuFLElf2g55G7l4?=
 =?iso-8859-1?Q?Sigo+jQwBYgtOfwYn9TsU+ajm1bDW+iuUwhl7Q7+y+Gs+/jZlApJlTaf00?=
 =?iso-8859-1?Q?6uyeJv6hAFZIz1H6d7OnCgnCdvgCoez0hcxVF1i1sgJHvNKZMdv68MbXQ+?=
 =?iso-8859-1?Q?Kavg4C4K5rLJf0XrdiLN6Tpc4Eqeflzp1Y/tKihNy9Oe65WcewuT8fHcpA?=
 =?iso-8859-1?Q?IbNyJ92iz7IUtXMLvvRv2t0FHAwplzafhK45m6HN6fs9WXhC6Dncl8TCat?=
 =?iso-8859-1?Q?h4dHMymrbwN87+W52MknfcXSUWhjnnaQ8gxi3EURaUJyysmR7PavrMQ2vZ?=
 =?iso-8859-1?Q?B6H2BRSun4oqGG8efwtDN28Fp1t0MhMzIru3TqCgJcM2Uz?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb44296a-dac6-4f57-5501-08df0e54a268
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2026 09:27:57.4483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x9MPyQ8ilyQwj7hVNJthKLF3ft/cEA9iVyxMaFP7T7xMSacnPDZuDjwnwxKTgQ4Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8332

AMD General

> -----Original Message-----
> From: Thorsten Blum <blum@kernel.org>
> Sent: Wednesday, September 9, 2026 12:30 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller
> <davem@davemloft.net>; Simek, Michal <michal.simek@amd.com>; Jain,
> Harsh (AECG-SSW) <h.jain@amd.com>; Uwe Kleine-K=F6nig (The Capable Hub)
> <u.kleine-koenig@baylibre.com>; Danilo Krummrich <dakr@kernel.org>;
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
> Cc: Thorsten Blum <blum@kernel.org>; linux-crypto@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: xilinx - use kfree_sensitive() in cleanup paths
>
>
>
> In zynqmp_aes_aead_cipher() and versal_aes_aead_cipher(), replace
> memzero_explicit() followed by kfree() with kfree_sensitive() to
> simplify the code.
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> index ebee37dddb1f..d9bd6dcd23a6 100644
> --- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> +++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> @@ -230,10 +230,8 @@ static int zynqmp_aes_aead_cipher(struct
> aead_request *req)
>         }
>
>  freemem:
> -       memzero_explicit(kbuf, dma_size);
> -       kfree(kbuf);
> -       memzero_explicit(dmabuf, sizeof(struct zynqmp_aead_hw_req) +
> GCM_AES_IV_SIZE);
> -       kfree(dmabuf);
> +       kfree_sensitive(kbuf);
> +       kfree_sensitive(dmabuf);
>
>         return ret;
>  }
> @@ -364,11 +362,9 @@ static int versal_aes_aead_cipher(struct aead_reques=
t
> *req)
>         if (unlikely(dma_addr_hw_req))
>                 dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size,
> DMA_BIDIRECTIONAL);
>  buf2_free:
> -       memzero_explicit(dmabuf, dmabuf_size);
> -       kfree(dmabuf);
> +       kfree_sensitive(dmabuf);
>  buf1_free:
> -       memzero_explicit(kbuf, kbuf_size);
> -       kfree(kbuf);
> +       kfree_sensitive(kbuf);
>  err:
>         return ret;
>  }

Reviewed-by: Harsh Jain <h.jain@amd.com>


