Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77A4F403E
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 12:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892892; cv=none; b=P/5ZT3Py+0SBVE8hyXg+d/m1C5V0g68ZUaFNsDnEotND9vN40y32g8DSovjHAHTIykBsKZ92ng5hoYPOrZdbj9xwToo12Tx1hpS58DqBlrN/oq5M6JKojXJVifLAwpKUF3qu8mx+jc/tGdpZe8oNiH1n14SpP+mqHOXIy+vh+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892892; c=relaxed/simple;
	bh=dJX+goGiefWsdYvJxAHQh28fm4SwKCDYWfiw2wG9XPs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lkWGcoHAi9iAOCLYkzD5WqHsRPN7RE7c/S9iXSBdoVGRMNXzCe5rz3PpV859iS73LQYNGrq9SNz+qVBXGqRr3+NVJuDbavDVjFV/5Ar72d/90pKmDcRnCBFqXJlzskoI3Nrqubirr1UkVKEF810X/BR3VTblxjEvV3L7g8vnHx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=V3If0U+l; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="V3If0U+l"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ccc6b11a19aso1047499a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 05:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1791892891; x=1792497691; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tsR5FKgrqHkN7GSSB4XxOg94MOrSNjHOlKhMZD0qpI4=;
        b=V3If0U+l2ASt6UIqa8eGY1scM2lPfyKPllcCk+7sqCiVHS8aufTQ67DTPSs9SXdqMu
         9uJIJtzEj/8T1lKqVK0zlGPlLsoDhMvhqSVkEL9cGKsD0m90ToTq2xJRGTVBytal2HCs
         dUMjGyBkTISfl5dVJIPITwY7RJ6rjKO23KJHtayir7jN5/+MGfe/E4fbcyglVSuckZz4
         HDJWAzpUgRg0bFnzzkhaqypCyTb8VGx+iVZaBBtOIhf+z5Hv8ZQjwGYq4g72U9UhzIH7
         8hVcyka4JSzPAGmK6iSLnJ3fnNgtONL2OFQuzkl2+wTfNrMLaJ3jO7ZPDiUPCM5Mcaln
         h2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791892891; x=1792497691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsR5FKgrqHkN7GSSB4XxOg94MOrSNjHOlKhMZD0qpI4=;
        b=LKLjuPEhWtJJlx38xXWlla+Ts89WH9I/ZHD/p5cnvMqmj9ZmC5psxPjB6+3hbvhdcY
         423i27IyaTFb19rmVwpltSLRWqQZPIvirywXaMKKEac7pvRgGI/Ryr/Xzj/507hQ7AwL
         26qBsiq8x9JRA2IOFSqsHEs2heTyi4H3ldZJgCFe/oqNjEq7tTEK0FHOiBGD7CmEcpG4
         WD+xYW5nXp2sep5dsq+AATK1RPfSDKZMTp0BCludicpL699FzrPeKgJym6WsTWaSDBVq
         CFaHd+5ZCs+K1/X5sRftra6OXg7XJc9ObK/kj6cC0SA8nM45mZTHfPvwslBueeXEib1J
         D9Ww==
X-Forwarded-Encrypted: i=1; AKwUvBw69qFT4Hk1LdPx3SHdOYfPLltOXAUUejFU/V5SaF9yjefrXvXlJJi0O3gxZEf1XryyXSDxuAQOnfsv100=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJsgMyvctu8zoK83c10xT2w1C13sI3x4Tj0LGeJ0sAIAQHZQUG
	PWyn2N2dTwxv0Cu2RSkKsX1Gi5co5WNzEZB/ZhbISmPDCUksXf7gZDvT/+FldhEOVw==
X-Gm-Gg: AYBFou2TbBmS+esf2PeZTaAOIKutT9RJIE1JXIeURYR4qMNAe3zbBMm+RFfbXdMD2sd
	wQBQefA+ArFOjM2Un9pQA5aLCv1oh0aqg0GsNCG6sO7aW5R+Uyc2jSzUythweUcyonZEKeU3X9O
	FP3geOpWJ/M5m86wh8XD8m0+1bqei/eAGlm2leNIkbitEJyhACnx+hEXlSMAnk9HpYKDaD9aZKz
	rNd6GTS2RQsHEcIMy8xdk2/EVAKxIggcjPH9wU2WTYVLkjV1VkRpJaFoMg+G7zAOOTcx20Rsp7J
	BImks2VKPrJSmB4agtPu56B8WBc7NwAeN02Dd1wsmnONM+/dQ0QujPlED5onr431MVH2q/o75bs
	1M2d92sAtMMz0O4vDDylTCIOTwKtFLyYWRL67+y3c0DBKPtQuRynk7M4vn04Nd6563zZw6lCSDr
	klbdc/fLe2FgIkvCF1hExbE2n173i34cSTTqsrMXLymnxa3R6zJfFZwvzQ66IssVaahY3t0Ojek
	5/uWN+Usg==
X-Received: by 2002:a17:90b:258f:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3ab3ae368c6mr9179459a91.50.1791892890015;
        Tue, 13 Oct 2026 05:01:30 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab8a393666sm16566838a91.15.2026.10.13.05.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:01:29 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 13 Oct 2026 17:30:39 +0530
Subject: [PATCH v3 1/7] greybus: connection: Export gb_connection_get() and
 gb_connection_put()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-gb-uart-transport-v3-1-81d0a8a1acf7@beagleboard.org>
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
In-Reply-To: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2142; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=dJX+goGiefWsdYvJxAHQh28fm4SwKCDYWfiw2wG9XPs=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqzh2CeW6DMpVMU+ZQxNRDCnXlSuaerwVN3ctuU
 fJTNs/QPOqJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCas4dggAKCRAFzvXHieVa
 dORyEADiYUcx/P707yxNXqADkim7p+gQ3XRlwg5IsquK4bn+dBr1KEcrn5X0AYexO0DURoDPhG6
 bd0xKvbAiqz1ceAL6n9ThIpDPTBtjplksE89OP0ujEDvyQ/PZyZu8AuSzfFVVgjUYrr0s5OgBo4
 h7YuTtq7uhB04sMAcy/Gsm5ruot8lGssOT9cMqVTiV1vPoOtwCoBMmgkhqqtHt+Uv2GChGl16A6
 GmniVFK4aDqPAygkVCi5ogMH1wkRRJMaFZcQKJ9Ynev+aviDVCgfL7sC0C/C1ALp1QB1Q0fPRlp
 fdJyAEN4tbQBnRYHD1IvnmEOakduYxpefcBg6SuQm19cOsOlz8kJJvC/xyKNhpndVB3AfhmGZYr
 ivqz0A6nqo4XeOpaL5Et+RGMWEiGtRw2i7L/RKiYd8uCyikrJi3H1kpvy42MbbcTyYVHqG+y1cb
 i6gbWJyAFPhNI4sCrxR7hhoy/moLWr+d3QI52SD1N7xrJgCcd3rhoQRkIFQssgVkJ5JvSMoUsHq
 6OhE6a2/CUI5hV4tCB85lIBgbVD1/tlNR/Swa7FrQ1i8s4yDOkaIbTilAMfepODR9wIO2MbzLdx
 GIr1phhMYsYfGzCKB+8d3TlamjBbXXiNd5jidVmRbu/6ERSD9nHBrnAdA+eU90lFIOPw889WGyh
 hTWE74LFQ50LsqQ==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

gb_connection_get() and gb_connection_put() are currently private to
the core. Drivers that hold a connection reference obtained from a
lookup helper need to be able to drop it, and drivers that cache a
connection pointer need to be able to take one.

Make both functions non-static, declare them in the greybus connection
header, and export them so modular drivers can manage connection
references. The first user is Rust greybus abstractions, added later in
this series.

No functional change.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/connection.c       | 6 ++++--
 include/linux/greybus/connection.h | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/greybus/connection.c b/drivers/greybus/connection.c
index bd04485decb3..f8fda22bc466 100644
--- a/drivers/greybus/connection.c
+++ b/drivers/greybus/connection.c
@@ -33,19 +33,21 @@ static bool gb_connection_cport_in_use(struct gb_interface *intf, u16 cport_id)
 	return false;
 }
 
-static void gb_connection_get(struct gb_connection *connection)
+void gb_connection_get(struct gb_connection *connection)
 {
 	kref_get(&connection->kref);
 
 	trace_gb_connection_get(connection);
 }
+EXPORT_SYMBOL_GPL(gb_connection_get);
 
-static void gb_connection_put(struct gb_connection *connection)
+void gb_connection_put(struct gb_connection *connection)
 {
 	trace_gb_connection_put(connection);
 
 	kref_put(&connection->kref, gb_connection_kref_release);
 }
+EXPORT_SYMBOL_GPL(gb_connection_put);
 
 /*
  * Returns a reference-counted pointer to the connection if found.
diff --git a/include/linux/greybus/connection.h b/include/linux/greybus/connection.h
index d59b7fc1de3e..b53aad2270d6 100644
--- a/include/linux/greybus/connection.h
+++ b/include/linux/greybus/connection.h
@@ -128,4 +128,7 @@ static inline void gb_connection_set_data(struct gb_connection *connection,
 	connection->private = data;
 }
 
+void gb_connection_get(struct gb_connection *connection);
+void gb_connection_put(struct gb_connection *connection);
+
 #endif /* __CONNECTION_H */

-- 
2.56.0

