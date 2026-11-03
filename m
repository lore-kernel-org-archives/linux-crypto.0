Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722379;
	b=d4Tt6JV625mw93oy1lfPeI+pd7MWzFYCojhUfLiMzFbhlhCfOVsKX6oP778oDtC54KqT
	 wh7rxzJ/MbfmYaGw5XGscLOK2F5RNEJwCX+fxyII+G+N7BjIEnZ6ZL/bN/9i5jA61F+6p
	 izxhDLPvMwrKUlKepn1JN8CVOKxwC4loMtDfaAumqXfnMEJ6viaZgCZVmt0++BgZRCHxs
	 TwBC2Bvnqrh1tqAjE/QzAEnZeTo9GVwHGwgTI+TqaWnVpzI4JI9HGzqD36OzJVOVPMTfa
	 5pCQFzTp3ylqWr+6LvWN840sr8g7qI4RMc4mk1CrT9ZV5i17xlE4MEOxIyce+RdM+VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=hSMTNzWMANqWlYxsoyKc+GU1Gc89Y6rRwgx6/XfOORc=;
	b=5R78m5PyJBMY2dGC1yio9kvMgvG3+3FQpgkQwmW4iTsGBLLV3cQGcir3rdFc3basWCwd
	 /+siqwo3GWJTRbUccGDv8wHHLiQ3eSAYN3K8C1p/UOFZQH36346fxxE6exx3vAmEtmopQ
	 2IxPIdYLGii6yiJzkKgTxrhKXMN2dtpGWKlKDrMDEEUzWULR36PyE21IGFtJHxqqtGNeY
	 1fqzMTFci+zS5F/JOUOfdvGTxqjkwc65q2NMrfZWyUoY8Kw0SqHB98tpjw3bhDBxw4VDv
	 jLsHmDfXMobxpuWv3J/f2HrW7YUEqZEPf0w6EHl38117UGpNJD9UUqKMIugL3D5JcTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=TCYWmWZa;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B4E606D825
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7B4E606D825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=TCYWmWZa
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-15ea896ddc8so7356283c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 08:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1793722378; x=1794327178; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hSMTNzWMANqWlYxsoyKc+GU1Gc89Y6rRwgx6/XfOORc=;
        b=TCYWmWZaCqFgI85/TpfZ98KMVon3DiDgKRYugDv45+Q8LmWrfKTWHmkQVREtB1tiRx
         HQaCVwM2bFCOsFjmHDsVfvukyXkLHpeHkz8L6tzGFmp4Oy7hTXPOgDSK4F+bz9ZM1nWn
         ZyybP4J0HhQdmsKH+71+tD5JoXFNwrR7dXp+ONXXGxcXQm+sGr3EmsChLgMSeLCvTYB6
         lglkvAXOHOuUbxWhreMXGQ+nJXAk/p3SQTCaBhJxEumAxdM6p1QY1sPEAFaZPIDIki6v
         rRfxKuigPTgOvEQuuUZZ8BD4LNbeIy/kgQYu82lGi1BCREYdM2Tn468Am15+Z/b54pcy
         aN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793722378; x=1794327178;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSMTNzWMANqWlYxsoyKc+GU1Gc89Y6rRwgx6/XfOORc=;
        b=n212l1uEkLMx+4hStuCri0W/9aRWuRKfePEJRywQrpqelQCHse60xSZdsODbelcK3c
         WorOp8GV9t9eah3no0x4C2VSZCHtyEaqrol+R4lJd+uZhc7SLYmC5RR/vGSrTD6uiAX/
         9WAYZ4uvPwG57ouE1Ohf7vwU0FUsFCtj8ZmatFWZLy4cp525Wv/inh4DWcG1cA/Ueokc
         thaZYHxgAoCFxykAUoE3ayQvkHv5L4ndH8iIUPYTGlHflQvX/j61dNmh5vQPLcvoaZqv
         UstQe9irjdJZamCRLLNh5s5ogmxrKS5+vHKDun5YEhKHTNVG4qH7Clcx93Px7FOWqT96
         PB0w==
X-Forwarded-Encrypted: i=1; AKwUvBzCFt9W4QVjN5vFaiyjizHk/6J2ri3MtCdVtKl7OW8RWVT3Jir2ovKLrUOk9jGBFFmDtywHei71ybrtRUY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Z8ju75ysuSdndc/hCeaI/RAbNdEamf9bPRw44fyp+VLZVW4eD
	n8GmNIAo8ofiL2zCymBo+ER4LOrzhPCOhOJmWUXu2zg9XGi6ZnqmBmXp2IiyvfmoVw==
X-Gm-Gg: AYBFou3GT7eKKx9RBxeg/Jrt4XWXbyePEwnKkwh/m1ztIoZ0S2i9Y7OXZoHcT388Foy
	bkyD5IZoOnYg89PyA8vEJWavMDyqYLjNkKojLtEu2St8mMPU4Fq3wL6PuatoXiGbeCuF49rqraL
	7vEeX25dFxtUPv/b75028PePoK6m5NE39fXLz3Yx7dn5x8GMtVyST0cebGqmGbPjRUh6H/ukNKj
	5dD2P3pTnrTLvrbolBPNUBAiTRJ1KoNWf60HsTM6n0rOTM2ykK+ZStFd3aeOK+6hvJlTbAHzIu4
	Ft1sb9ityYXd9//eOHQmEiYBBs02Vvh0r2NWGXPRwnHo2hKv3pFSTjO0Cs2MHBtJbdg77+jhpbN
	7aOzQJJqbvFFxGYxTFZwY3NOzNwAeyFqqtUHTRLoaSiI4bSr29o5ctS5++Zr4C5EXgLC63LOA6g
	Dw1zWvcLPY9K133WMnZLjHDoqZrvka0SgJWVVzAAFIAFRcVOQeBzjmMSsQJ0StpGqydALprnKFx
	YyY0uMvvVvT/g6bQ8GIsn3rqCKRETJ9/ZFun9e4FZwjeC2xKhniyYtsUI+Nk9aU+7ab4XIFrbRx
	H0wHfu+RsSL11M2crDM0WqOyi+c+a0DZb92/TYjg
X-Received: by 2002:a05:701b:4241:20b0:143:2968:564c with SMTP id a92af1059eb24-1ac5b9cb040mr21210378c88.26.1793722377822;
        Tue, 03 Nov 2026 08:12:57 -0800 (PST)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm47214021eec.6.2026.11.03.08.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:12:57 -0800 (PST)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 03 Nov 2026 21:41:50 +0530
Subject: [PATCH v5 3/9] greybus: operation: arm request timeout before
 sending
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-gb-uart-transport-v5-3-f8e326d6561f@beagleboard.org>
References: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
In-Reply-To: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Markus Probst <markus.probst@posteo.de>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=zpOdmfpBKhgDMSZ3lQslDxw8tphqN8m/HcEZLtVnRY0=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq6gffPq0afsUXss+TmBdVdcpnwmES8qvVoLoO8
 fS7Dc+JsBaJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCauoH3wAKCRAFzvXHieVa
 dFAUEADCzZFb4PmN4Rj+2VqSKvaqBBqV1/9MMgt1W+ePRdZqR2RiTnya+lDjXg76JvCKC7OaJJh
 tPF4igoaNIvSeMnln1nUF/c5JmeqXUOvtr8iZNVddhaKHTBjhu8RO9QW5vRmymDn9VHi5y5Zc57
 jdRvwIzTBspkV+aeZw3jha9H1VQxRQZ28Elj0GMYRzcV7hbyuEerljz0mC+sLJ7DQH7K0HF4URR
 mqBQP/viA7KP8jwZyxzha2TVxp7/6qQ7uvlPgOF4ev2q58pH5QgGE0aY0IzdsxEJ9TLEkoE5SVe
 KcKjQI6fj8rpb2dOOIHS/NwNhpcyOFBeBzi2ehtKW0hyb00CZU00Qm/tf9gMnZ19tFLblr0vL9Z
 eN7B3nD4r2RsiYt/JYM1Es4ZjPVhxgWwtupkOf+7Y5ss9qcHGukalGPJSg6dmINyw2kySgXqonR
 EMnhdNMDXQVKCitMDg+GvvO24uGQWvLjlVWmmMnzIRJhNcBN6KZEfk8drCV+YSSehwa7Lk9ShkE
 CIAS2oed/ThFJR9r4Ekh8CENJXPhTKo1FRO3AlMkm3j9PmEtKoiatAbrgnX1jbvFUcRQq3YKyoq
 wWB5Pz8+FmmOUy9k21LGNWhqUeoT9xxDMmTwot0WDvYbxUfr89m00XeYfWozvgbn/GNGrwldMtg
 Z+TSFS87f4yWb0A==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

The host driver can complete a request before add_timer is called. The
main case for this is softsvc, although, depending on which transport
is used, there is a possibility that response arrives much faster than
expected.

By populating timer earilier, we prevent the starting a timer on
already completed request (which would then leak an active timer on cleanup).

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/operation.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/greybus/operation.c b/drivers/greybus/operation.c
index a63bc2eb164e..2d37acedf36f 100644
--- a/drivers/greybus/operation.c
+++ b/drivers/greybus/operation.c
@@ -782,20 +782,25 @@ int gb_operation_request_send(struct gb_operation *operation,
 		return 0;
 	}
 
+	/*
+	 * Arm the timeout before sending: the response can arrive, and the
+	 * operation complete, before the host driver returns.
+	 */
+	if (timeout) {
+		operation->timer.expires = jiffies + msecs_to_jiffies(timeout);
+		add_timer(&operation->timer);
+	}
+
 	ret = gb_message_send(operation->request, gfp);
 	gb_operation_put_active(operation);
 	gb_operation_put(operation);
 	if (ret)
 		goto err_put_active;
 
-	if (timeout) {
-		operation->timer.expires = jiffies + msecs_to_jiffies(timeout);
-		add_timer(&operation->timer);
-	}
-
 	return 0;
 
 err_put_active:
+	timer_delete_sync(&operation->timer);
 	gb_operation_put_active(operation);
 err_put:
 	gb_operation_put(operation);

-- 
2.56.0

