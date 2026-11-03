Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722368;
	b=CGeWMUXcQGAmWjU/sZPTnFUlZLtD61luDuMYxY4C6MGBBMyscFvQX0CPQ8p2wTk3yb89
	 MjOcO0EUu9VJJK2SPmUjSDPrKmaDzcJdOBHktaMftDlP2Df9h4rJOwRRuL+rsdbD9qCe5
	 PbtrrlaZsvmT0kJlHFmjoDxjhgaqcxoPZ/SHBFQOychCRPm65bH+bXoNgzNryUGKcFvbu
	 976wfjxFFflk9yLindi3vqzhb3dUIvp9B8K5ae6dzU3C48VZk9BShFQhC14nY9QKrBaAV
	 gBx3qRj9kVgSppOCJ06UDacVA+SY8GLK8SohlKjP4X/QqOZJIBv5XBmsCcIw8qE7iGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722368;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=7ioXeNGoQl9lc7Y570BlNDeQal84QvGenHazRImLOrE=;
	b=X6dJgTAiQyW1IyGxviA3rRPZmal8cLsZlJ4Dt4SGP7c/GYzuk0dKVvS76pDy8lEpARZy
	 uayVRAutzpZwZ7mKUZtJNlQ1ncj/8HDLLf2MUxiks39VdUFt3koK6Z0txvsh3/zjOyM2T
	 oqthqTRXniZL9mf0vm8WtGhJfYJFPgxwG/cV1NJXm2aTBbWEnvyPHqIXFMCdvpsgcCcOz
	 SZEnBplI/GqKL/Cc+GhzRWFsOSkHk8tmwM34DhonZcyf44J+zhn0/pJ2RKFO35ovJilnC
	 Xf3ZBFLJdgZg44CXN/RQl/AzU6wUyo283ZQNq+ucgCcrgudoaqg+KErAEDA0tzcjGBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b="IV1W//k0";
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BC2606A32C
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:12:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86BC2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=IV1W//k0
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36661f953e4so6565914eec.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 08:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1793722368; x=1794327168; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ioXeNGoQl9lc7Y570BlNDeQal84QvGenHazRImLOrE=;
        b=IV1W//k0LPH9DUOAnz2D5JRScaD44LuAFIbXFdJN6DaiHIvmVSyDo+GAfCks9XWCX/
         VlPmztLmmH6ErKGS/Xu7hsViJBPOA6v20MMt5n9/gN0blS4EKrY/w+SVlCd38LbMRWQP
         Sk3BUwm8fk69T/wwEZuEbYiTZiqgDmWhaEFW1XkVNLL34l1TmncQA7vE7qEmgmFJFBQf
         JiOoBDTqWFFIjlFT0eDAV6Cftdwfi/MiSyWzYcjqCcIFX8aDig5mucRBwv/+PkQm3Ga9
         vhHv3cVAZC+v87lCU1gYJHP2OP9An8rAymI+7R/Z31PrY3Ng7Dl6EVO9JGvGSeWeH78I
         kJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793722368; x=1794327168;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ioXeNGoQl9lc7Y570BlNDeQal84QvGenHazRImLOrE=;
        b=VoJ64xuz37WGtO5eed8RkmzPDMgjf6rbAlD6xxZDyhRUOlrW6Xfb2TfDt4r4maNG7J
         2+VLzeAZW1UBLj9nc+OtDL5vyD44eHJ6r7VGrhGYcs8W3eZjUkWKYzniedwPaJulpSUK
         RzBCojFpgS5JPptDjTZozZEqx5KDPOksJmBoIklACEKdN3ghyaACuyfZZ1zHcLTRlUkb
         QrtEjxmKAddQX5hY93Lu3ad2o1hI2lncJuRBA6CkzIJheidpwhkdp80p+yCxUkH7iwVy
         EhA7HgTxBZSycvDC2lCj+/GVKoGFqXbSN85W2KZn0ouwQxgQxuJzBeYPovkHw5Gz8VHn
         PMxg==
X-Forwarded-Encrypted: i=1; AKwUvBzobdkPiTD2AK2vbRQEVjDoydBZHf7nzm60SEXfKpdpHMTLGixrGP4lLPgK0ATBuz9kIMVDtFrhdlglDl4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9fOwZH1494ht3Gy9SX7O/yzdB4HGq85q24n33uSozEct1JXeGN
	joFEu1vbxdvfJDfeYf7G0IEso6uK6esoMkn+j+cXCvjn/3QXc+BZvKrCzn14nVItCg==
X-Gm-Gg: AYBFou3wa/zJU0OiAX4nRKH+enn1JnQzLQgN0YxwH8UmXwm3gBld30NwmbLzY5BczSl
	ljF+b9H4f/K1DhpJjEu+s1bBuXmPXt+TeTHMI9Ih+feALqJdb5r1Z5frT/jAxMtxUw5+XHZWa/r
	/etFFEff6ZPwTYgrAXfVeE6im25txx4u7jNh4Psf7/Keo8Tq8gfFltltDaNNFEGPP1fJ9wymfFG
	/DitSIzkbh/HBWROXAM+2D/Aqk/BwDE1gUTppmHr2W+SdfZGpVss4/sNtIDYyjQe0cAxVYyLxvK
	Vn9gimOTJxqEl3UPjAaNekbxkPxxNALLtE1ymuN/3rlUEBTa56mHSiWrh9pko6OZ7DIAKIgAOiN
	EE6rh6oEDlhQyu3FmzrTDVYIgsBaabmpZPTyZmY0sj+NQnJbbAPwfUuh+etqeZwCVDH9cr7R0td
	rduWfY9s3hZmfOKe1RgKDkHY5cKbMTznGnufh0H+vk+VGoBiYXgYeoNlDuQVwbIkZ1k7LQvokN2
	W5XWie5TnLGjA2jwOhSaCyma5/MYahfPT5gP8EtWVvev9Vjc0EmjUuK4jd/V55hBAGUHs8jZmYe
	Z6FAXQZRiodAA1O9ZOK0d4tu4ottLE7Tg1JVyp63
X-Received: by 2002:a05:693c:414f:20b0:369:e930:6bc4 with SMTP id 5a478bee46e88-36a423f6f4amr20779058eec.30.1793722367527;
        Tue, 03 Nov 2026 08:12:47 -0800 (PST)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm47214021eec.6.2026.11.03.08.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:12:47 -0800 (PST)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 03 Nov 2026 21:41:49 +0530
Subject: [PATCH v5 2/9] greybus: svc: add gb_svc_flush()
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
Message-Id: <20261103-gb-uart-transport-v5-2-f8e326d6561f@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1952; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=leFklJHqSM2Agexfq76WAyMkgy+VatMb+l4RrmRvEVc=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq6gffxreQRs7TJaFm5zqIwRX5Xi5Jltc++k1bo
 aG5dJ7zHjmJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCauoH3wAKCRAFzvXHieVa
 dCprD/9rMZgkex0abhAVOa9YiUlwHr1P2aW2cUH0d6ZwazDnZdvYtYd83Q0OTESCns5ujf2EQ6t
 s0NScLrfHPhMZH1sQ31fEfsENABtei6FOdDWE1ME+Ygw3e8ilifdL83ydvU2kt75J/i33k+Ldtq
 4olwZV8Ppqji7pM3+oFTyXp2BedRbuIGnH4cInm6urkQWbDLG7QLjoM6lhVcyBJDksVIQZ/YP5H
 1mnOOO6dkY8v367yfTWsOsqNYxzvF7+IQpvGDsKR/OEB2kTU9gJC2TQxdb/Y96DzCiCLkwiOYpu
 XcOd1O3pZMSKM3hL8rkLSKTr1/b6FcFHeQkr61SJx/QIn4TScC6pD3DrRrBLjDekpJp+vLx/s/a
 6bHKaaeKmqbUG2wFsD7gtz4vIB76raBLtU8C2MU90YcKk1vapTEFIRCEvUf94NvjTCFvblZFAjv
 IFTQ6wpKA3u4VtBN8anLe8uCsuTO0lrSTU4dwdU0tsAQrscUnj0FfmGEjUnnFkeiVQhY2JOU26N
 OZD7m5NAMjbmfN5MnN2HsxgnseoMOy9SD9n7f43QrJLckgV5tKsqMTKmV3AYUP+56d6mYK01LWD
 9B3oX3i4t5yGlM2cO6GrT02s4W0TNJdgWMZYIuDcj1Pa2w5Oi2pyngaIrzz15bPprvvBYQTOAYS
 EoPcaGoJSn89XKA==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

A host driver that is its own SVC, such as a software SVC, injects
requests like MODULE_REMOVED through greybus_data_rcvd(). The core acts
on them asynchronously: the request handler runs on the connection
workqueue and queues the actual work on svc->wq. The response is sent
before that work runs, so it cannot tell the driver that the module is
gone.

Add gb_svc_flush() to wait until every request received so far has been
fully processed. It flushes the connection workqueue, then svc->wq.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/svc.c       | 14 ++++++++++++++
 include/linux/greybus/svc.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/greybus/svc.c b/drivers/greybus/svc.c
index 490577731a19..788d95b4b87b 100644
--- a/drivers/greybus/svc.c
+++ b/drivers/greybus/svc.c
@@ -1381,6 +1381,20 @@ static void gb_svc_remove_modules(struct gb_svc *svc)
 	}
 }
 
+/**
+ * gb_svc_flush - wait for received SVC requests to be processed
+ * @svc: the SVC
+ *
+ * Requests pass through the connection workqueue on their way to svc->wq, so
+ * both have to be flushed, in this order.
+ */
+void gb_svc_flush(struct gb_svc *svc)
+{
+	flush_workqueue(svc->connection->wq);
+	flush_workqueue(svc->wq);
+}
+EXPORT_SYMBOL_GPL(gb_svc_flush);
+
 void gb_svc_del(struct gb_svc *svc)
 {
 	gb_connection_disable_rx(svc->connection);
diff --git a/include/linux/greybus/svc.h b/include/linux/greybus/svc.h
index da547fb9071b..ced5fc3a9c6b 100644
--- a/include/linux/greybus/svc.h
+++ b/include/linux/greybus/svc.h
@@ -63,6 +63,7 @@ struct gb_svc *gb_svc_create(struct gb_host_device *hd);
 int gb_svc_add(struct gb_svc *svc);
 void gb_svc_del(struct gb_svc *svc);
 void gb_svc_put(struct gb_svc *svc);
+void gb_svc_flush(struct gb_svc *svc);
 
 int gb_svc_pwrmon_intf_sample_get(struct gb_svc *svc, u8 intf_id,
 				  u8 measurement_type, u32 *value);

-- 
2.56.0

