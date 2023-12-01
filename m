Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jkz96203"
X-Greylist: delayed 2354 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Dec 2023 04:34:17 PST
Received: from out203-205-251-73.mail.qq.com (out203-205-251-73.mail.qq.com [203.205.251.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332293;
	Fri,  1 Dec 2023 04:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1701434054; bh=qzS+a2Gr/bakLJDquWrIuh9nnLPsR9rYDx6NHkqJfrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkz96203VhEmjAE5VVj4yl0dagh3UI5hZBwqZj9DCJaSzZNZKtx1RW6N2115wMN/j
	 n1c0qmXDduj5fBSuXniN/WzORdaP0apu+rNA0AUiJHiqHw9PMCoMDwasm1q9l4iDrt
	 UfY1qH42aRxXnc+3YNyR7wc8KJ7sybPT2H07oR1g=
Received: from pek-lxu-l1.wrs.com ([111.198.228.56])
	by newxmesmtplogicsvrszc5-1.qq.com (NewEsmtp) with SMTP
	id 88B898B5; Fri, 01 Dec 2023 20:34:11 +0800
X-QQ-mid: xmsmtpt1701434051tgo4e6xsn
Message-ID: <tencent_B2D2C5864C49BDAEE0AEC1CC9627E3C6CF06@qq.com>
X-QQ-XMAILINFO: MgAERLP4sJkUsTrdVsdxMjk1EWzdZzO70F/iKgS6sMr83NZ8TL1Gg6XpA8dc73
	 cvyrRjN/6WEIRAsrDcNLKVtjwZfVh08nB9na9V9GcnOE4eBSkRij+4mVS47sZ4X8V0JSPvTCXgfq
	 C3t6vXpNnls61kv7d2vBSwNvQA6YxWGmKRo9x4MfSPw6xsp+E2L0gYdUyMfTxuubyV7trHN6V5LG
	 jYGp6+IIsgbfqQLyWXudAAxYfT3DLq9411pV0iphmCTiSVCLnMOwZuC+rFP+AW4ui/TOeYbLC7+X
	 X7H00kf0eSuLlLyEnWiNMGPcMs9DjMN+d3MqYt6hkBFhbGiqZsocDYMzBNUffH4UA7FkxJSZed/7
	 zo/jX1OjVxCY+CK5O8MHVkxWx5FakdRjQmcE0irYFagomRvvXZ8zXSgCv6Oa94ysWD4wL5HfRO1H
	 0a4ANovR5phKLyGJfo3fTt4mmPzekVfxDd0JJaEQwv+9M6zJC9e09QndmmxxD5/8Xi589bGdLu1C
	 ye9E4BkjDd6IDULHzstoBsvJp9CXBs6VJClmAc9w9L+vQd+zOF25SmN6qKH8vFY9QdgsR5lw5h+i
	 sxgb4NY7wWnHmO7dWLCCPx4tJPzTzEnMPFboPzOpx1amf7rsMHWH43EZ9yqoVcVCZjDYePDmf/yE
	 IqA6szfq6uRific6GPKHaWf7qJFMBwADjXIP+oO09uRyqVPVszbe5U9m7dwPLkihh4Hkmx28T+hY
	 j2aIo+ZOMX0CFP0naIzD6frcUUJk4qKUcfG2TMnCq5BUT97qUV2gbg6xvKlLMrdufRmE7OYm6BxE
	 oKG0ar9KzDVqbn/5GwmcI/1IDdOfQS5Nu6KGGItTfvm+qq4bUnqf9HMUGq/mnfBlaQePo+Jclyk+
	 Z+K01b2lVtYLFHvdQ/CWgITf6mevenDJkE22mDHL1bTIqa1yrroETl7iIbJCnFKUH1z7mO0V4B8P
	 HebdffnT580SlG8HizXg==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	eadavis@qq.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] hwrng: core - fix task hung in hwrng_fillfn
Date: Fri,  1 Dec 2023 20:34:12 +0800
X-OQ-MSGID: <20231201123411.1806073-2-eadavis@qq.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <ZWnGV39HJr9uUB2/@gondor.apana.org.au>
References: <ZWnGV39HJr9uUB2/@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 1 Dec 2023 19:41:11 +0800, Herbert Xu wrote:
> >
> > Reduce the scope of critical zone protection.
> > The original critical zone contains a too large range, especially like
> > copy_to_user() should not be included in the critical zone.
> 
> Which part in particular is taking 143 seconds? The buffer is
> only 128 bytes long.  Why is a 128-byte copy taking 143 seconds,
> even with a page fault?
According to splat, after a page fault occurred, the attempt to retrieve 
rcu_read_lock() failed, resulting in a timeout of 143s. This is my speculation.

Edward

