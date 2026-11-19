Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795074618;
	b=CMKl8O5VuQkAJXzpjf+iRYSgFISMQwTRonxW4dundujdl5q064pn5TTvdixNEBqH3rc1
	 uKEKkLaWPay/O7cjvjup+aZ7Wu1hGbQCMyHOns2XdlBDqDL4lJiTUoapWA3TgBll+MPp6
	 XbgMijpQwzOQz23e51vBqGd0qXkXJS2l4Gf2RBBAwOBfnEDSNsL9e5PEGG7/WvaeMSNwj
	 bjAfk7B4GKBu9Vd/NBAqSuRE0bd5kUPg+rgv/eCEfHR8waojmj4UjMUx7/RHsMD9HUJII
	 rKpXSPxpNS1Gn+alldcJdSM4pfCI8v8xJ4SB2Vn/MzZ2v5OnyMlusi5A9hb//jqc09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074618;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=M0fogLi5ax9AIJyqEcKXM/SFejfozKfYTgP4oiOHUjA=;
	b=uaHqP6vZJ2VPR7Hj/IxVqLSFwpWb2+6QwgP0k6DBGbe5Zhoho2ZTuNHXkiFRg4Q9M/dZ
	 +yQNYUl2Rks6PrYEOYBe7TtKWSzHL7UXlgYKF9izmQfW9iPXaJ9X87yz/JpHGwBsCI2E9
	 /C6pm/2i3v39ttrUihm01ID3tpLIIq+1RUEadmPT+Zu0C+/FShTyu8p4UgQI2Cm7HAZWI
	 mYUSF8LwCQxC70wGAxfkn2t11gvSANzzUG5g3rllxWx5adw82t+ErOuDv8gEZAUXLmx2K
	 quJozU6E7KG/e35ybTrVu1sQAw9eDNy9PRliyCkbCtAo8JhDagEYMV4zKbYs0sJfYhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32096606A336;
	Thu, 19 Nov 2026 07:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32096606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d8283e56e3ed11f19a56ed5b684f684d-20261119
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR
	SRC_UNFAMILIAR, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d572653d-0e28-49a1-b381-3b32eef7f5dc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:d572653d-0e28-49a1-b381-3b32eef7f5dc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:a84d96c141e57ebce9ec158666a80d79,BulkI
	D:261119155012M4AVR27P,BulkQuantity:0,SF:19|38|64|66|72|78|80|81|82|83|102
	|127|153|841|850|865|898|915,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d8283e56e3ed11f19a56ed5b684f684d-20261119
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(36.106.123.207)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 794733331; Thu, 19 Nov 2026 15:50:09 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Florian Bauckholt <florian.bauckholt@cispa.de>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: Re: [PATCH v2 2/2] KEYS: asymmetric: Fix PKCS#1 decryption of an empty message
Date: Thu, 19 Nov 2026 02:50:07 -0500
Message-ID: <20261119075007.689405-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119-keyctl-pkey-fixes-v2-2-9e2d1c7db7ec@cispa.de>
References: <20261119-keyctl-pkey-fixes-v2-2-9e2d1c7db7ec@cispa.de>
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

On Wed, Nov 18, 2026 at 11:19:29PM +0000, Florian Bauckholt wrote:
>  	case kernel_pkey_encrypt:
>  		if (issig)
>  			break;
>  		ret = crypto_akcipher_sync_encrypt(tfm, in, params->in_len,
>  						   out, params->out_len);
> +		/* Returns 0 on success and always fills the whole output. */
> +		if (ret == 0)
> +			ret = crypto_akcipher_maxsize(tfm);
>  		break;

Checked both the pkcs1pad and raw RSA (mpi_write_to_sgl()) paths for
!issig, and tested with an RSA-2048 PKCS#8 key on arm64:

- KEYCTL_PKEY_DECRYPT (enc=pkcs1) on a valid ciphertext of an empty
  message returned 256 and copied the ciphertext back to userspace before
  this patch; with the patch applied it returns 0 and leaves the userspace
  output buffer untouched.
- Non-empty PKCS#1 and raw RSA (enc=raw) encrypt/decrypt roundtrips both
  continue to work as expected.

Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
Tested-by: Guicai Ma <maguicai@kylinos.cn>
