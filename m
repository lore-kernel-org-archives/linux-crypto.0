Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A423E0096
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 09:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787217984; cv=none; b=njTgBzobIY8QpvY6nOIenDjJvxzw46KAs5TN08+FQm+clmUISwhagYnhWzpKPOF6uLYNP2jO7AxMadk9psXkKkVUNNv4WkVP6j+zcRkj1W0wdR8RFQiYg1j1TYB5g2G9pFOSyZvPieY5f5VLRSgNmvfjZqDvFePr+lAoWD3fJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787217984; c=relaxed/simple;
	bh=6FWZ4CXrC3IC3UxJkblN8Q7DcfXAsxDSRH5/oQe6mig=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dtjmlVhx5iSkqjj13nXrwt2nYmRp1xrEbQ308p5ORO0M3aKnPTyEh5xgrnM+9++6BRHhickfCs1EeZgCNix/8T9nfYIaTxZhbX37pu+orwCxDm8+UZaP1sxz8sFPtPSBZ/jrVC/3QAYX5r3yay/XQV6bixLGjDBWhc/5yOwKkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b=cU4FvBSM; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b="cU4FvBSM"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so2722903a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 02:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard-org.20251104.gappssmtp.com; s=20251104; t=1787217974; x=1787822774; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cW0TGNliGRgRHinSfGnJ0XJ0b5NU2E5kFB50csiZw9M=;
        b=cU4FvBSMrwiBxsXmcYA/92P5EjnRgSqvA3peJrpd4rIc2c/zlpe8SjC1B2uKaeO59C
         Ah+KLJD2EcH/FMOwhUx/wW2c/ihfmSe0TJHKH8GrzevFrH7nRKFMhzA+f6aLBAg2PAEI
         cEEOgq5fdYMr6ZKExvaFij3KEPg4p8cdfXM3zX4WBRUN/wW5ayX16hG3LmT8DmWGd7PQ
         472pPQ9MCgxzEK4tB4pUGkrYqo5ueebh+SyZaINqO1snUR0E3iNMfyMq8IGiN3hIaIUB
         MJpgSf0SjCa4y6aBp4YfMiD3sxiSRPMVSAgDuLMajJlyuGNEXSLPZZvW1EQQgDyEgvXN
         kJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787217974; x=1787822774;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cW0TGNliGRgRHinSfGnJ0XJ0b5NU2E5kFB50csiZw9M=;
        b=RDPsJ+tPFuF/vhYgu25/NX27h4knrkqeuBV4vWEhiIXd3w2Tz9LwSrFr/MyAmQu2sD
         cxI4mJ23Y8cS6+DZCFb066dTDnyL2SFL8A+Ujadm+tl6ZHs6TB4h8oa+UWs3BUK6hac2
         muza0pLDyxqXckt/07g66wbZn4aw8DcCvK5Y/6VvckRI4cYkOcyMX5SOwKSYJs7uKETQ
         FHahYYXlHvvrCgxZCcCCsp5lZ1SObz3osSJ8VqpESLWmAYhAzkh7w0DPEg64MFtoAiIY
         tv2vnsUpLuOKfY/DexUQYFUIq3Z4zTPg1OF6GuTaSEp3rNtsgDHDTg4aoMTHkUKWuhQs
         W8BA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/6WLhOzg8FosIbV2wxp0BtRACSt34VV9g0daJn+ZY1yEVAFxXd+qDIHgxe7qD9Rz7UWHL+jj2XyABAu0=@vger.kernel.org
X-Gm-Message-State: AFuF++lYxV2sumWpM6GCgAf4txrn3O5qFY1h1xoEUNLnEXL1g7985NO0
	YLTaFT61jvMfHDIXBzo2sKyyeMAvHHcLGT9Ir+Xz9pOeU/r0OjjhIulNyGQ6z/Xg4w==
X-Gm-Gg: AR+sD118uLAZbfcqKeRChGJn7F3TR6Qy5cwmXMdPMicCgErpn/G2n+K/sKdCrEYdJph
	gorRnPA0Bk9J0jCgs9kCfPTjLDTZdz8IM73QS5mjCxQ66/DqM3rOALrfQdfj/nudlPf/Jr0LCoI
	hpH3RmLVONDs18nyd9/2obdlFjsmgzVfTzqUq3AvjnKaJ1Dry0xWMhjMuya+nJLmZc+IZwTJOyk
	ahhhHWMJfVWDwXEUampiuE5OBSMkzPZbJ1CYR/54dN82vpbkx+31s6R+uEbMYHugQ5rvcaeBW90
	jjwnyYPqp1jcCzHqffRLVJBPfKZf8c7v/rVvwmv1YfYbOy55AO70CU35xB0lOOelX17w5jeOsYf
	wB1R5aY8kSK40UkUvrVBjmbMeS1KIBdSbnY67R/4Pz3I5BkajdbtmlplKNgtfjo1ZVjMZlSpiId
	1tnv/8fz0HHC8cFxxVQJucGHAH8rSa6fuG9lcZE4oqSrT/MJYk+72kQQ6E9JGa5aftG/YbkYw=
X-Received: by 2002:a17:90b:544f:b0:381:152b:d596 with SMTP id 98e67ed59e1d1-3958108a4b0mr21950129a91.11.1787217974316;
        Thu, 20 Aug 2026 02:26:14 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad6060asm25903254c88.6.2026.08.20.02.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 02:26:14 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 20 Aug 2026 14:55:44 +0530
Subject: [PATCH 2/7] greybus: connection: Add
 gb_connection_hd_find_by_intf()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-gb-uart-transport-v1-2-282da14ab7b7@beagleboard.org>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
In-Reply-To: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
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
 Conor Dooley <conor+dt@kernel.org>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2390; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=6FWZ4CXrC3IC3UxJkblN8Q7DcfXAsxDSRH5/oQe6mig=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqhsgczHXrqaZlvmoyFYXnGxoC8dnp2zg1Ri0jd
 JgP8jvepayJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCaobIHAAKCRAFzvXHieVa
 dI9ID/4qUt8idxVlT1iSbVUvHo/2lFcqC+y1DXdyEaW2PdRkza7VruIwciXjiG6N7KtVNGpLeQl
 b6vfdN4mEm36VdJZVhWMr45v1hTv0eNQbtYGig3CnCO+BMSyLaiZqMZReVY3ATAQpq/m8zWcLny
 YrFeNSl+mBOQkzDp4G53qBEY1lV6E4DfP7rjWwzTCZ2HyCy8/ilSe70P2EQzQgICTBeX7rXbXU8
 Rk2O5Y0/wigAbF0Q7HH8xklk6lWzHzzVVI5QowLo80aHy61tpw6T0afD4/PyG9LSCQ/lVI/JpqP
 TJlGTt/52+ivF3DTUQYgnMqIx3syr9DGvYpuCUTQdWxLYkrMUraYpVaz0GtHDCvhqAEEI6fuKVV
 APrEsHkAtKB00aLSNeSPRJ/VFKgeJFgEZkPQvCVR6C5QfwBvsrGXGSaEwTxAFqbaqY9a4MvB9XV
 +E3FLzAs/wFTb9TBxH9pAYgKg6300sYmZTnqjXpswVFcrIVqp1Ulb2Umh1vbCj1QANlzUiYsps1
 2+gb5Pc2seYoWTeCt/9mbdyoryj25sKRXDiAl35WPRUiKDcPN2ClifW0y5u0Lo52Pin6vGKRKvP
 yqwP4m9ZkQZidP3rH4R/GAymLLauTTdZLUgL/J4suT0m1UrRFZu61Zb0I+HYQLYqsaR6Xa7r7kg
 UbZyAiyUYq3lPKQ==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

gb_connection_hd_find() looks up a connection on a host device by its
host-side CPort id. Callers that only know the remote end of a
connection (the interface id and the CPort id) have no way to find it.

Add gb_connection_hd_find_by_intf(), which walks the host device's
connection list and returns a reference-counted pointer to the matching
connection, or NULL if there is none. The caller is responsible for
dropping the reference with gb_connection_put(). The first user is
gb-softsvc driver, added later in this series.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/connection.c       | 22 ++++++++++++++++++++++
 include/linux/greybus/connection.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/greybus/connection.c b/drivers/greybus/connection.c
index f8fda22bc466..262161fa4721 100644
--- a/drivers/greybus/connection.c
+++ b/drivers/greybus/connection.c
@@ -71,6 +71,28 @@ gb_connection_hd_find(struct gb_host_device *hd, u16 cport_id)
 	return connection;
 }
 
+struct gb_connection *gb_connection_hd_find_by_intf(struct gb_host_device *hd,
+						    u8 intf_id, u16 intf_cport)
+{
+	struct gb_connection *connection;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gb_connections_lock, flags);
+	list_for_each_entry(connection, &hd->connections, hd_links) {
+		if (connection->intf->interface_id == intf_id &&
+		    connection->intf_cport_id == intf_cport) {
+			gb_connection_get(connection);
+			goto found;
+		}
+	}
+	connection = NULL;
+found:
+	spin_unlock_irqrestore(&gb_connections_lock, flags);
+
+	return connection;
+}
+EXPORT_SYMBOL_GPL(gb_connection_hd_find_by_intf);
+
 /*
  * Callback from the host driver to let us know that data has been
  * received on the bundle.
diff --git a/include/linux/greybus/connection.h b/include/linux/greybus/connection.h
index b53aad2270d6..589721d46015 100644
--- a/include/linux/greybus/connection.h
+++ b/include/linux/greybus/connection.h
@@ -131,4 +131,7 @@ static inline void gb_connection_set_data(struct gb_connection *connection,
 void gb_connection_get(struct gb_connection *connection);
 void gb_connection_put(struct gb_connection *connection);
 
+struct gb_connection *gb_connection_hd_find_by_intf(struct gb_host_device *hd,
+						    u8 intf_id, u16 intf_cport);
+
 #endif /* __CONNECTION_H */

-- 
2.55.0

