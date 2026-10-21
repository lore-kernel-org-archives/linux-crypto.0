Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792582701;
	b=R6DFlg1DibQwDAdNFH48QP/2SuuWiXXZk9Qn8+2QFzKTXQhsPTWUzBGvO6QWqgj2pP1w
	 7BsPXyvs9MrgclQsKO7YlTSZ0s2e2kDQ+tz1SNEl6po01txjlDMI3XHnPvT+wRpYZgei+
	 wFd05flwdRnnluG0UfZcwEwZQk1fHfD6HqkGgv4zy2NjPk9OxjBuPJkA54XIlsgPU4X/B
	 p+8rMGUSxj4D+XwHtf96BDfag9m/7qOaFohuMa6dEEGZ5nkQ0TYphIeqPvthKp/LX5tqC
	 CnFoAuzvgbPEWpLQMFQfbIOmTnIl1awBv/Lgf5oS+tUkEa49CfQtG2zMjqJQ+nvUTMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792582701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
	b=VHyAssL+wRPvnTtlJ3++yfoNRI9jBxGUzyxDDLbeGxVRaq2bj/UdpEk4mREjMso+XIwx
	 MX44ynHQds6kCII77tWD0S9/wNwjVB4t9IAMHnbbdZQmeLHD030g8jy8A49iQlyFsMKJH
	 cyOqt3jPkrdc0/IrgcdhuDEopouM3rrnhF+XhCfzQgy1U3Cmv97W4DW62jRe3zQKBsRVj
	 8fG/GYO3SqTSJVIbGcyAlJznVRI+9JNcAZF7l/B7EFwGvIehPcUAPE9VG3XIG6eMo4CTy
	 ZE9JnoYuAtDFBTexiRikhEEu9tFI5AsIRTzJdUtslq3yXLtxNnJx//KAzeBtXs/92mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=YzRsx4QB;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACE1606A31F
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 11:38:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ACE1606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=YzRsx4QB
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc147d86bebso401789a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 04:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1792582700; x=1793187500; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
        b=YzRsx4QBfV/m9qTXtJPNXP25sUBMq92tcfW4vxziuNNnF9FHtp5mNpo+CwYjs/xiDC
         qgZW8b5mJ/Tj2VLcwxKXikGb67DxVWBpvjrMzhn0PBK8hsJ+a4w1eOVfwDoSg4LyAWvJ
         f8J7n08SSwsDl0Utfgcaw8c9UtLkD3PAm4EtbTo7r/pAGaj+EmVM9OX18Kkg5dUGYan7
         JC56OXo4up+IkpNngWRND+h7cmwAA4dVWPnZ7BmPTDToXfecbLMZhyqWc4fBKjTyvuYs
         JMpsZf94zbqrcAxNcEibwYmUHaiDff10RwpV1989a278AiZ/yUTGoYRYItl4dCJLb8TZ
         49Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792582700; x=1793187500;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
        b=LyUzZYRvL2I2YTqeohFJIRcCqX3GtUbw7BrVjuJWc+eL4SAIBFnsNSzV9uwxMWv/b0
         rtiZ+4JkBSvC5wQoyrNbiDC9NoejxcLmASJM0saYkFP/ugCEs+H2dr0aD1oG8/n3EgMg
         IMWI3zNXBC9o/n/S0pU0cRki+I12B81I9ldx6kzKPArSmJkAode985amyg7faieqnvzd
         DvXHjIUuRdOr7Cx3mvfknrUAtM2WxL+FrWK5qnGuWVKcYpJKH7GXno2lPhZK+511/AId
         5BFM49FG4Y6sQondl2zDe6NHkFyenS53eZkcKuIus0U+mHn7bvrXQawyc/l1bRXomkZO
         VqgQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjH3OnEoSKCO4Kgs34VN8wwXTjvIc9qemeVLEmgUXUdaHxWS21klSXuVH4gUQRj8IbCbJuy3lEghm22DM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJvSQlYuNGUgGpyBZhK4vQyZuAf9GWw5ioQe3hS+zQIphDPdLNU
	1MCwXOXE17HQ7f9i8d+LUMeHG+/DAMZ00uN0AIXLIESDBa/7xB7IFFKuWmnrir+bRg==
X-Gm-Gg: AYBFou2ycwM5wg7LS7zaNPzleUG0tHnUEgXgE1rbp3jpi2EyfbgKwB6U+oMqpR5dKLU
	sbld1HxlXfaJuIEJa6TTZXRA7NtPDAUp9+zWL02Qtp8ijFNlscb03wC2aHBJrxavhgs6yz0IUjE
	6TRRtJoDMs6l/RXCCYfvGZilj0ntZPnBQWGxvflEGc4KP43eC3w8t4WgN3VOWBxBBDOWf3C2fjL
	B86COZNv0cm+788jwmXe43zz3zLHscGGmnnIBU2bYMm4kRk4rQjHTZc0AfgftIM6xl6fLB+J95v
	+hhw4qg4tXYjqUoG95jkIJ/xQ8IS258WD17vj/RmUydot7QrBdZRliebESNOSccG9du7s4PyHiS
	om5r0pe5DsUWE8vRW/YD3sjUyaqHAH6sXjE+2vfugToAVgODnJNksiadOG4MCFzlXU/3AdhCr5d
	mmdTY2oOzvywNkoFq4q5cYXzxdd8YEWk05JQDRk51meDne8Y50lKyTvG8sg66t9ahcw4f4I3XG9
	pE+0AKUiBdi8+MmhHWaWyijDKEgt7do2fsghZW3rPJPcJPPLfh6jxITDrYMrCsVC3U=
X-Received: by 2002:a17:90b:1b04:b0:3ac:9ed8:f30e with SMTP id 98e67ed59e1d1-3ad86f4e243mr980248a91.35.1792582699721;
        Wed, 21 Oct 2026 04:38:19 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813eb9casm4023732a91.15.2026.10.21.04.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:38:18 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Wed, 21 Oct 2026 17:07:49 +0530
Subject: [PATCH v4 1/6] greybus: connection: Add
 greybus_data_rcvd_by_intf()
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
Message-Id: <20261021-gb-uart-transport-v4-1-c308ce821d45@beagleboard.org>
References: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
In-Reply-To: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3382; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=NQkRap6CrOtYznHYWCc3/Rny1VeDCr57c/dGW/aAz94=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq2KQTir9RS0e7OqmIJkCLUEaMm/mJ8o5D+lUxX
 ELoU3IDcwKJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCatikEwAKCRAFzvXHieVa
 dOv8D/9RePHi4bb9upiHyBECA2O/ZADrraGRh97/0d9ZxIW2rhvHM9sLbtuz07cslcMpmXfavgG
 19hsaZX9WcterTlip0Ny3mMvlWP0ZMMaCBt/pt0qBYLtKQ8/VjR6DR+f25ZYGIpfK8vHj5w1zOZ
 n9/6Xl/Tlg/k6lqu8jhJrr07MhD1230XOVIRuEm8tGQY2/x7L6qhYokjdySTTQ/3JnuSCRFjudO
 9P4e6LFSuHfXMliDrQQNiC7eYWswSYEySuM8uyGipdAaPRFKgmTg5U2KzeOZMXceqCa5APTQFbM
 n3EpIlkdjpblilMV42PhbwX/vQQFP8q6VQ5rGlHnuso3oNZPLUKw9QXvRuVIm56oG50YTf2KJLv
 7QiEsRCUzk9IkYSFNdQ/H0LrNAFF4WSnV1dE0N2A1+qoI+wOrSZ5+kRKAvl1E22KXmoeMb5Gx11
 6YatPkm1n5pMXJslRYnR/lNayyJRbDVRIjzK01gCGq/k2kI4JOD8hI7qL3K74yi1Gyfyu5YSYSY
 wrS9rcE4d6/ktWMiR5kq4SVE8Y0kslSUXQdj++3fYHi/6F2jeT7pF+OXja6e3vkw0+O4402FiY+
 VT/aCU03zk9pWEStksEyRN7xdRbz4VXW8TJ9fTHqS9RrdWDf9cJP140Ah6XVlJT9Un/ZZeKSSU3
 VyiBOzZ3GLeSwyg==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

greybus_data_rcvd() finds the receiving connection by its host-side
CPort id. A host driver such as a software SVC sees only the remote end
of a connection, the interface id and the interface CPort id, and cannot
deliver data that way.

Add greybus_data_rcvd_by_intf(), which looks the connection up by
interface id and interface CPort id and passes the data to it.
It returns -EINVAL if no such connection exists. The first user is the
gb-softsvc driver, added later in this series.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 drivers/greybus/connection.c       | 47 ++++++++++++++++++++++++++++++++++++++
 include/linux/greybus/connection.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/drivers/greybus/connection.c b/drivers/greybus/connection.c
index bd04485decb3..ce8646299ce8 100644
--- a/drivers/greybus/connection.c
+++ b/drivers/greybus/connection.c
@@ -69,6 +69,32 @@ gb_connection_hd_find(struct gb_host_device *hd, u16 cport_id)
 	return connection;
 }
 
+/*
+ * Returns a reference-counted pointer to the connection if found.
+ */
+static struct gb_connection *
+gb_connection_hd_find_by_intf(struct gb_host_device *hd, u8 intf_id,
+			      u16 intf_cport)
+{
+	struct gb_connection *connection;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gb_connections_lock, flags);
+	list_for_each_entry(connection, &hd->connections, hd_links) {
+		if (connection->intf &&
+		    connection->intf->interface_id == intf_id &&
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
+
 /*
  * Callback from the host driver to let us know that data has been
  * received on the bundle.
@@ -91,6 +117,27 @@ void greybus_data_rcvd(struct gb_host_device *hd, u16 cport_id,
 }
 EXPORT_SYMBOL_GPL(greybus_data_rcvd);
 
+/*
+ * Callback from a host driver that only knows the remote end of a connection
+ * (interface id and interface CPort id), such as a software SVC.
+ */
+int greybus_data_rcvd_by_intf(struct gb_host_device *hd, u8 intf_id,
+			      u16 intf_cport, u8 *data, size_t length)
+{
+	struct gb_connection *connection;
+
+	trace_gb_hd_in(hd);
+
+	connection = gb_connection_hd_find_by_intf(hd, intf_id, intf_cport);
+	if (!connection)
+		return -EINVAL;
+	gb_connection_recv(connection, data, length);
+	gb_connection_put(connection);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(greybus_data_rcvd_by_intf);
+
 static void gb_connection_kref_release(struct kref *kref)
 {
 	struct gb_connection *connection;
diff --git a/include/linux/greybus/connection.h b/include/linux/greybus/connection.h
index d59b7fc1de3e..e8be67a936a6 100644
--- a/include/linux/greybus/connection.h
+++ b/include/linux/greybus/connection.h
@@ -92,6 +92,8 @@ void gb_connection_mode_switch_complete(struct gb_connection *connection);
 
 void greybus_data_rcvd(struct gb_host_device *hd, u16 cport_id,
 		       u8 *data, size_t length);
+int greybus_data_rcvd_by_intf(struct gb_host_device *hd, u8 intf_id,
+			      u16 intf_cport, u8 *data, size_t length);
 
 void gb_connection_latency_tag_enable(struct gb_connection *connection);
 void gb_connection_latency_tag_disable(struct gb_connection *connection);

-- 
2.56.0

