Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722358;
	b=K0O8BCUpU2oyMOt4GYUbQNlz01CkhJRcWkaz44TiPxKRoDwOFMCNV/tJgoamVASvrJrI
	 FfnUI25O1R7/c5s45n4wM8M5z7UNi0zXE18Bb4gUwt7jy1li4fX6LslL4vHvmuyMJDwBu
	 XEFfxZGu2FHwIInBk9FONfv+kmas3MOcN96OW1ReZ5pIS5vz0y669ORZ31yFugaX7BCGX
	 ACok1Gbye8FNUKEHSazqYnmZGQPkKGFoY632qV456D9l0QF7/pAH9I0TVAGm1qu631XLZ
	 CTnuzky5K0sZzPf3wM5cKo03IpFPL2k2SFlumcMQYiLHdA2VhMry1Bv0r752ko59hnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722358;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=iU5C5/OkbP/mHfQmlmymeaJJHUTP1UrWfMP2HJrt0ok=;
	b=0I64RvLE4+j80Z+LNBe8Of5rghpW2W3CFEdgVB3e2JWSA73iJfzgHmISKSN0vQx4dhSj
	 AnPMVlkytG7JSX8sWsjmMTfe8480QC+Yts4FKGvLDhsMx+4+KlN74niDxUyr7TqgTvP4U
	 OcTbVLuzZR4Qe6Wj8ar3tjWYHwckGaYicQdM9V+be53fewD9MLYc6meEG6M7h9YDwCZlW
	 9z05jeIV9ut5nvhRrdMXyNV33C8O9TiA1SdETKslJd4pB9LIqcgS3rPoj4WZuQVYbQWkh
	 Ci+OFnnzn72AG5l54SfawFH9OQx28au3CJn1BiR8InnuCfE4YVoHZKCm3M4gqOCGXsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=K2xPQoGs;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774BC606EE8B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:12:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 774BC606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=K2xPQoGs
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a2761c69fbso7461059c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 08:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1793722358; x=1794327158; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iU5C5/OkbP/mHfQmlmymeaJJHUTP1UrWfMP2HJrt0ok=;
        b=K2xPQoGsHLhY0/0ukrvjtUpDmmWht+hhyNK/lzr4qmXaw7b+2n1UIcWKoWsngnuFLn
         MNnPH1UurYIgOmXZxm+Ao5ewmR/C4ZRriLk8Bo4hPhsNjQ64LsQfRH66lLYpQZud/UB0
         uZ144T8z8OtxXX5p2/FAC/zlFJHx0JvUd9JPiS7ZjHLgobJ4fKSqMjOxep93Qd8Mj7Tf
         pevX9Dpt8sab0n8umGdq1yL0S1TzmfJ1P7Y2HL0byweKy1p65HJBiGe343mV+nfY5+Qt
         XzzhTgL86fuxQrL+ExoJMwP3fat5Eu8zdw+m7PZifAdA+/X5uk7SxOvRWdlKOI9hWScZ
         47Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793722358; x=1794327158;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iU5C5/OkbP/mHfQmlmymeaJJHUTP1UrWfMP2HJrt0ok=;
        b=DJBYYPHy5zIreS6bm9kY9O+LkfKaAJc/wibu/Y24uIa8EP4yecUBUVLTEtLX9JVj20
         y/hudvUIX1qGu1gjqxMRbNGHyfYd1vIK33KiJb4rqRVrcQwio1rxNaRmCGkbadASa3AV
         2CcdujS0BzZXmZz+HWQuydr5VkSo2F7mUdWIiAahbhT9gfm+DQlbdqq0FhjDlDGtSmO+
         nw3e9wXb2nhyi0nymhzm7/Ult76yUSS6xVFV+wn96UkF+5THhqQsdQkHAM90GODnzriN
         L+MMkA8T0pqeZg8Wvvzcd3Dp4RIFPlOygNHsCelSOjno+SlmtvHVjOBg+WIuss3l62vk
         QXuA==
X-Forwarded-Encrypted: i=1; AKwUvBzrdoBEW8tj6bfznrofzJochSIQw6hzp5dOxiDfFBQl44/Lvg9Cu+Yarrmh9caySU9phXTbFk0cQr0BOdI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+oyqu3x0ss4otRV21Xacp5qv4O3bYLKzfBdD3DgCtGvgCiDjD+
	rdM2SjJ10C1wzIth3GI1Hi36J0SOkn/WKop6kU5gy+R9eQqmvVVpdzodhFd40zp0pA==
X-Gm-Gg: AYBFou2yCmynCzBg3U6q4vd1p6AdKzX1LJ9tKJmAUWYMMjgw/YT7SW+lFSuIe5yFoic
	ni2a84vMxgqkCLSP5PHSuw/TgLnXUUhWqH1d4MiCpTunPLtIeQTp58yg2Z2leCCRfhpmbO9Owi3
	AV3SkSeu8R1F+YjAsTp61zqb+66UuIcWv+/GhhOF4AAPdNSUbWHYm//4upnCCy7tuhn9/8J/4h/
	e2TOnbaSbKMZZNTJ1k05r3aiKiHQuuUNa1NKgF80OrhsOzfG0ux2+Kz6mYk0FblHh0Hl6+8N5RA
	UHv+8VUwi3EavkKIx527SfBQMfYny11J4hPqVFjN9LrgEZH0/FHQQecrq1k4cXv+uzcFNLHIsxC
	ofuOO2TGxeEzF61OOmy3LDVOug5Xq5ErBenqACTUa7RmvHBvPSeV6KDZ8lhmS5oF4tvO1RhYA27
	C+qg22MU69LxnEMkDKSKl8GVkV+mUAqC59ZmV8qtkdrU6CBKVyJQ7/ZpC4onMghmfa30uGI0dHU
	Hg31GJ8RQDZRwMNxojrIKvIB+cf+4r6qvxY6FhCHsZsAumRB3da9Yq0Xbe1z+s7HBtw+jSQ6fmC
	FrLfwCEn+Rj+yuYIPFQtGASy9yE/uA+xbcqJVucK
X-Received: by 2002:a05:701b:4250:20b0:1a3:f368:5a41 with SMTP id a92af1059eb24-1ac5ab53a12mr22895531c88.20.1793722357340;
        Tue, 03 Nov 2026 08:12:37 -0800 (PST)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm47214021eec.6.2026.11.03.08.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:12:37 -0800 (PST)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 03 Nov 2026 21:41:48 +0530
Subject: [PATCH v5 1/9] greybus: operation: keep request active across
 message_send
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
Message-Id: <20261103-gb-uart-transport-v5-1-f8e326d6561f@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3228; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=MvQe+DgFaMcXzVZSj9U2FX8VhW8LyI+3Lsz78olAE4w=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq6gffz/rGgZ8sp30AZYi986laH7YSeSBXVTilB
 ukuAIzPEzqJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCauoH3wAKCRAFzvXHieVa
 dL6pEACrdLRShuNWiKfcXdCjwJA/AflYkX9lIZJoKIjBwygV6p7PxfzCab+742ZWiEHUjWk0N4S
 lKnMIkvnpjfAmZUXyXH3rBgLlXpm4f9GLNpSfkPg42HqHOxLC8R5d2Y1taoIsv42TY12AmL+S0K
 D2hZ0/BU3zcXc3Ae8SsYTn4nfygkIAPJmiNpCskhIVHWm3yF+zAoeH97GwekIgdq2YuBVsk8TI1
 Z/ORgE2WyAS9uRW3QhR1tRML/V1gIY/Hyv92Bq1OawyLxAk/B5IFqzlXnwR17KTgeaWOvnJP829
 DT5ejPyfV27Vqce3hPR5DEdZObwg4tDK2+7lkFxb8djzEEqD17Zflz0ri7oVXhEWyFmoETkhJ2e
 57WDsX+Ng6yhzvCNU8wP8Jz5oFN2fGjf/2PloOSIyK0JANFXOGSg+fWmzMwK+GqINXtaVPh5Nuh
 k8EmcmEx/ekoHswneZYQh4rJkIFQoeRkHuqPYhoQfd1ix6h25wl/xrWmNjNoJIY9LO+cnrRPoew
 FiFODQJRMOGa+FllGe2ZBwG+PH1EPkmt1A0RyMEjuDUF7HHuqXIlnAMTOJ55QZvwdZRG8cm5oWu
 SlvdM3qeEpaEWMuuAFqCjPFkifOtL+S5KkHsEvlbqH2xo1is2aa0Y8u02goPVtmXXou0ZzxqeZr
 Qp4hOGX/hqlRDzw==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

gb_operation_request_send() takes a single active count, and completion
drops it. This would be fine normally, but in case of cancellation (in
gb_softsvc context, this would happen in module_removed), completion
(gb_operation_work), can drop the active count, while message_send is
running.

The core does call message_cancel before dropping the active count,
but in most normal circumstances, cancelling an operation that is
already writing over a protocol (UART) is not really possible. So we
are only left with making the core wait for the said write to complete
instead of making active count 0 while message_send is in progress.

The patch takes a second reference and active count before the send
and drop them once it returns. If the connection starts tearing down
between the two calls, return 0 and let the cancel complete the
operation.

Since it took at least me a while to truely understand what the initial
sashiko-bot report meant, here is an example:

       Thread A                     Thread B + worker                  active
       ------------------------     ------------------------------     ------
  1    get_active()                                                      1
  2    gb_message_send()
  3      GbNode::write() ...
  4      ... blocked                state = DISCONNECTING
  5      ... blocked                gb_operation_cancel()
  6      ... blocked                  result_set(-ESHUTDOWN)
  7      ... blocked                  queue_work(completion)
  8      ... blocked                  wait_event(!active)  [sleeps]
  9      ... blocked                [worker] gb_operation_work()
 10      ... blocked                [worker]   put_active()   [:292]     0
 11      ... blocked                  wait_event wakes, returns       <- too early
 12      ... blocked                gb_module_del() returns
 13      ... blocked                [softsvc] Module::drop finishes
 14      ... blocked                serdev port closed, unbind done   <- bad
 15      write() returns
 16    return to caller

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/operation.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/greybus/operation.c b/drivers/greybus/operation.c
index 7e12ffb2dd60..a63bc2eb164e 100644
--- a/drivers/greybus/operation.c
+++ b/drivers/greybus/operation.c
@@ -766,7 +766,25 @@ int gb_operation_request_send(struct gb_operation *operation,
 	if (ret)
 		goto err_put;
 
+	/*
+	 * Completion can drop the reference and active count above while the
+	 * host driver is still sending. Hold another of each across the send, so
+	 * that cancelling the operation waits for the host driver to return.
+	 */
+	gb_operation_get(operation);
+	ret = gb_operation_get_active(operation);
+	if (ret) {
+		/*
+		 * The connection is being torn down, and the operation, which is
+		 * already on its list, will be cancelled and completed.
+		 */
+		gb_operation_put(operation);
+		return 0;
+	}
+
 	ret = gb_message_send(operation->request, gfp);
+	gb_operation_put_active(operation);
+	gb_operation_put(operation);
 	if (ret)
 		goto err_put_active;
 

-- 
2.56.0

