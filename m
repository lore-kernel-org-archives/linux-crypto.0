Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=140.205.208.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094856;
	b=GEDdeJS77es9WsaYH8tezuAYhyG+dBOYKZYLTLxc1f5Cqzv5hu9SJFPI88KuDTNHP+OP
	 JdMeSRGmaBlfGwGV3ycvsvt4Gcw9XFtChziNb0zz+lf5HH3dSG1Xafdi9Z2BmbV6J89sh
	 nlTtuOBJ9bGihYxsKPJAfDmuJQyRLwJA1+ixEviSF3CboeJQrvaWXFIrY6G3Bl+yVpr1J
	 PinKXeH8qqiAoA3VEyWcIwUG5uKEi8iBvTciunobo1vUSBD7zZlhl64xGdo+4AOXo3oeF
	 aYT9WGK4JmetGlJy7VYcBEhYQPRRgUV6GNCrKIoSBtzILunGn87IE+sC5sDQzJWgBGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094856;
	h=DMARC-Filter:X-AliDM-RcptTo:Feedback-ID:DKIM-Signature:Received:
	 X-EnvId:Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:
	 From:To:Date:Message-ID:List-Unsubscribe:List-Unsubscribe-Post:
	 Reply-To;
	bh=4kZ4Hbf9Ip8FdqH6Hl2r2Au7c5UfXZBH4niXoxnwLWw=;
	b=HcEtWCAkD9rvnAJvfwJW2rOZy1esL9zAgys/jhDmL19ubFDyfQ1EsokTiMrrSISzSLf/
	 7vuurrKUAMCXUTIQXgJjKzq/vXg2zubPfzTMPMBXu76nGQjmVpEafuin5i8Zhwu03JBh8
	 rWZt6g7zGdj6JhuTXGE0yj26RdRH32u7rNRTJoBhnel1912s2Ny4JTsG5xO+EvxyX6xaz
	 6Bylolxt/sICRXA8N/1lrO8ODWQjn3/xY+xbq3kMdVPH8FYX7mY2Vt6DezzWegG8RQWR8
	 6yU+As6LS0okioOFoj21HFkPbAbF7lG6EsT0nVZ3LzsDx6Or7bKnRxVJ4M5oxYROxVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=token8341.com;
	spf=pass smtp.mailfrom=token8341.com;
	dkim=pass header.d=token8341.com header.i=@token8341.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou header.b=TL1FtpoQ;
	arc=none smtp.remote-ip=140.205.208.123
Received: from out208-123.dm.aliyun.com (out208-123.dm.aliyun.com [140.205.208.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BFA606A320
	for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 13:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45BFA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=token8341.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=token8341.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=token8341.com header.i=@token8341.com header.a=rsa-sha256 header.s=aliyun-cn-hangzhou header.b=TL1FtpoQ
X-AliDM-RcptTo: bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZw==
Feedback-ID: default:northgate@token8341.com:vip_edm_SmtpBatch:555662
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=token8341.com; s=aliyun-cn-hangzhou;
	t=1795094844; h=Content-Type:MIME-Version:Subject:From:To:Date:Message-ID:List-Unsubscribe:List-Unsubscribe-Post;
	bh=4kZ4Hbf9Ip8FdqH6Hl2r2Au7c5UfXZBH4niXoxnwLWw=;
	b=TL1FtpoQWiCnNiroH36kjMucG306gDYdwf0zr3EYz1/fuTIeXUqaqb85QSfKqYA66j+47HDre0Q+QDP25DrqY1pk/ySCb9d3QSRsOljhUw6I3O9izoSjhADcWBb1StLjO5CTnNhm8/++nYYhAL7WKrq+xwndSlVOspLBx1voxmE=
Received: from localhost.localdomain(mailfrom:northgate@token8341.com fp:SMTPD_-VHcGaBVLPJ cluster:AY35D)
          by smtpdm.aliyun.com(127.0.0.1);
          Thu, 19 Nov 2026 21:27:24 +0800
X-EnvId: 600000375210473180
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Subject: =?utf-8?q?token8341_=E2=80=94_an_API_partner_for_your_project?=
From: TokenWorks <northgate@token8341.com>
To: linux-crypto@vger.kernel.org
Date: Thu, 19 Nov 2026 21:27:24 +0800
Message-ID: <179509484408.2361083.18369440569221917466@token8341.com>
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Reply-To: wuqiong@token8341.com

5L2g5aW977yMCgrmiJHku6zlubPlj7AgdG9rZW44MzQx77yIdG9rZW44MzQxLmNvbe+8ieaPkOS+
myBBSSDlpKfmqKHlnosgQVBJIOiBmuWQiOacjeWKoe+8jArkuIDkuKoga2V5IOiwg+eUqCBEZWVw
U2Vla+OAgUtpbWnjgIHmmbrosLEgR0xN44CB6YCa5LmJ5Y2D6Zeu44CBTWluaU1heCDnrYnmqKHl
novvvIwK5a6M5YWo5YW85a65IE9wZW5BSSBTREvjgIIKCuaDs+i3n+S9oOiBiuiBiuaYr+WQpuac
ieWQiOS9nOWPr+iDveOAguWbnui/meWwgemCruS7tuWwseiDveaJvuWIsOaIkeOAguiwouiwou+8
gQoKLS0tCuWQtOeQvAp0b2tlbjgzNDEKaHR0cHM6Ly93d3cudG9rZW44MzQxLmNvbQoKLS0K5aaC
6L+Z5bCB6YKu5Lu25a+55oKo5rKh5pyJ5biu5Yqp77yM5Zue5aSN5Lu75oSP5YaF5a655Y2z5Y+v
77yM5oiR5Lya5bCG5oKo6L2s6Iez5LiN5omT5omw5ZCN5Y2V77yM5ZCO57ut5LiN5YaN5omT5omw
44CC
