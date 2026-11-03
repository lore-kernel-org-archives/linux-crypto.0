Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722389;
	b=P3G8Con0D03Cq6lK+sErsJNINcXHW0WKwhBapzUTz6BEhmugS/aPYDNuafeKq9KjvwKx
	 9nlLTlOM55co9fbWseE296qfJ6KRw41Zbx5TX3gMcehjdFDjno87NsdTA7jxHs7D3IAeE
	 PfHc0qKObdC/hazS+1uGrm8oP9hkzUAVEGpjPQWM6wEriNZIXaOLHzM1l49TzvijdacKy
	 92VlHB9pcirY94nLJDiPVwJ35SYFwtC/A/VOG4/hJuZKwz4ELxU6YN4oHcpmmWQ34wMx9
	 cBn4da6jkhyssZKbn/VWr+dAhJ8X/roI3Rf5foDNtg8SMPFT6iePOEpd0d6OSxJuhOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
	b=qXF4MrlVG7ymrxiu3We573fDxAdsGOc9HFzNl+qH2nEq68uX1R4pIZPerjhfyNyPSVwJ
	 v5wPFGAI+77YpWtYFKBLKYlssvosBE5KSBF4z1llFIqgsZ/zBzSzJj0Xg5vioE6jYx/gI
	 bvLGCD0TLEJj9GsxZFFHCDuan0bdcAWKUpT6JhT71bF5D+BhuHkhNl6lr6C7yqtbaiymg
	 +Y3Bmc/f2DOKjTuut1YdXRM8LFbG3yJWzjil3uY6T0qzmIj2E/oGhXHzWMgB6h6EKPLxu
	 xreabmsCF1KTPNk+6vuSDQClwAOUr9ZQ8ROt7/iCUwdgTb8DrcrwaMm/S6b63FApLHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=KJsQKIiU;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7316083603
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 16:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B7316083603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=KJsQKIiU
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-35829219da8so971540eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2026 08:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1793722388; x=1794327188; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
        b=KJsQKIiUye9c4bySIE7fMcNiKRKjWCFbfpFxtOfzdg3cXG7wG8op8njz3Jt/xUATjp
         aj6P6PY4Zycjx2SQVEcYSiDh2hW1s7RJvHYCAIdbdXtfTwMbHx2f+n5ZtKGTWqUqhKtH
         vVOdMMsfVwormVvVcsmNXJIgzrGKFoyHydzSJPHuiMJ5soaNNazX7u4slV2jmtDEW7hL
         H62vvW31/t3lMWvPhMi8P18tIuLi1+sDlucz7yUpe6MHW+4DAfqNe26YAm2ga8km4MB0
         H9xiWsK+eNjFoG6IgWmpSe1tsFFyJWghY9KGLv+2+UoO30KsaxEa/xDZvvxlxjMjYJdB
         druA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793722388; x=1794327188;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lZvKug11Qy1xOLHr4w2brybIfbioQkbDZg8gHZ1x0Vg=;
        b=EZYjVzbX1WHRuhARZFRmj0qd3H/nG/6+eP7wzGICL2CAjaTatTWMWXYZAJmlnWVEZu
         fzYGMo5WGCjeGZ2mghyrMWZ2rUl5oRtBE1N4qacuvjxumd/YtBhmYhBYLO4ZdZHJ69oZ
         ybDMMYYlCeMPP/DELDfFiUgT0rdPCc37mnk0Gi3diOHe66akkXESCKafp14xCSbtdF4T
         v37+mdifgsCdpL323JM89+tQjQa5ls6mtQJgSvuZCU2pf40NFs93pRL7FYYBBoTm9FB6
         ua85Tr4Js6dEjkOyoDXBWmcV0nYEB2GHpAZyg1Ax1NpMlsjTiDlHQ3lUTEtUv/ZYzLHu
         QFEA==
X-Forwarded-Encrypted: i=1; AKwUvBwe4aeX9W1ip2TbsbN4Ccs68efuAlDMJKWFMkuK8JL2oPTmlrCvbGX7t4r1itRbQ4p9eyiTsS8ZpD2mDGI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8qNwUubbNuPT6eXvYpQu62rcVor6ErLAttTOoOcvcIsW7yMY1c
	t6IU8d0QQkux6lBmbqoJous8kFoaNsDIwLitwUtUNXUPnK0tSYSFtVw3ukNs4LiesA==
X-Gm-Gg: AYBFou3rrioLubGkHQoVm7WSTfrp56fXjOEwDcZBhidu8ok9k12YWVy1tmUJ6/xp1zD
	AID4Epcdb/cv8RYVnvb+27I5MekMy8fRGAcibZvfCERoF6WxoL1w+kbHGuMZLIU72XgpSyYmP6a
	9r386ANyIbEOLtqiAlCo6dln1lzXB5VW4zFeuIBymvI1zvqETZzlnyGeQyyxoniW3vvaPfOAe/1
	i95LN2c5lwbo0NDHunyo6QwiqfvlzS/MNZ1LD9BbgwPaH0yD0H0kkrYGdphzEy0nAdmQu7RCRi4
	YCfUYwg8rF35lB5Vs8LrLjRSfn6wCfl8lDSQBrc768vpiE/IHuiWESVKP0b+YXdmtvcZZ/FoG4T
	sCfPPcLMwoD6bps+wIZoyl7uAK47OJ46Cp4nO7BPTW3jMUyncp8/KqgSWAWSmuM1Ldpfh6/wC6P
	VgcSmre+dxIovxd/UYahV5YTBFa5l+QHr1K5w55cXYmKyWzqSa4dfprLrx/swY1kiMtQ3odI80W
	+ZM0nefYuMupiSCUvWhou+3vYBISxoXXBOGn680Mrtk9GSbEr6uafUkFXwuQgEVVuxiFhRGMHju
	P/WlSybEk56vt3CDSILFkl1TCdyxYATTUUUfO5Cp
X-Received: by 2002:a05:7301:152d:b0:36a:79cd:12df with SMTP id 5a478bee46e88-36a79cd1c3bmr4623541eec.9.1793722388005;
        Tue, 03 Nov 2026 08:13:08 -0800 (PST)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm47214021eec.6.2026.11.03.08.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 08:13:07 -0800 (PST)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 03 Nov 2026 21:41:51 +0530
Subject: [PATCH v5 4/9] greybus: connection: Add
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
Message-Id: <20261103-gb-uart-transport-v5-4-f8e326d6561f@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3382; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=NQkRap6CrOtYznHYWCc3/Rny1VeDCr57c/dGW/aAz94=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq6gffg820DCEJGqOfFQcVV07bFl+sFBJgEuXJe
 7ZnMi1jofaJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCauoH3wAKCRAFzvXHieVa
 dG1EEADaK9wNwE4KDujDDlx6LnqQ0zT7FogvGIwBTyxcypD6WJhpR1sUIi9wOu2W4t2DLype9nf
 S2njGym0X35iibqvtVHVYyWXglFdOAQiTBJntKuizvXp4Wd7BRPFNxieqO+xz+wPozF7raUi0oc
 W/G0eaU7ghNnQPv0k7ro6547Wa0gpe02Y6/6UPpcd5sx9u7u2wl1decZEzudNSILc0GUMZhfiAi
 /u3lO1R1sFEEke+8E5ttTw64cmUczBrEdsM1/e097r/LCMjfLPlwSWW6Eus6NBiJTfwGdrvD3f5
 NodXdoKLSFWHUZeIhTfwN55dx9T0J0I57GABJxs0Q92HThf1USS9QrfB/L1oUkIvj6y9YPd+GNp
 BsiwGihTgb6pQhi+Rw3PkiQFEIIeOUUjR4zpexH3uUR2kZCVBP7qCa3c7IuCgxQC4O2bv+D81N/
 yWlcRluGh/7aLhoSM9/qD7OONXZSmXB2a+jfgpsxqKWFVylHSw2Z7kQsNFGr8GrP4e9U0JyWX4j
 u6pl+KpLPRwMHoWbB7Vh4AB/JfZylKJzw3rpk1uH2U8lQcS9CoNGqDJSl8fzOLW9aa5+SNrQiCS
 nDYc5VlNs+YUNAG81XdWfJmagiyy6I6O5hZRyaHh4FbL35uknhgpchguaAoo7MXvws9pcYFTt2l
 ttb/M6xVkWlqvzA==
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

