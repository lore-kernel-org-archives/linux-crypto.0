X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Dec 2023 00:11:47 PST
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCCCCB
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 00:11:47 -0800 (PST)
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Mon, 04 Dec 2023 17:09:29 +0900
X-Sender: letrhee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 946;
          Mon, 4 Dec 2023 17:09:25 +0900 (KST)
From: Dongsoo Lee <letrhee@nsr.re.kr>
To: 'Dongsoo Lee' <letrehee@nsr.re.kr>, 
	'Herbert Xu' <herbert@gondor.apana.org.au>, 
	"'David S. Miller'" <davem@davemloft.net>, 
	'Thomas Gleixner' <tglx@linutronix.de>, 
	'Ingo Molnar' <mingo@redhat.com>, 'Borislav Petkov' <bp@alien8.de>, 
	'Dave Hansen' <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"'H. Peter Anvin'" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231204080217.9407-1-letrehee@nsr.re.kr>
In-Reply-To: <20231204080217.9407-1-letrehee@nsr.re.kr>
Subject: RE: [PATCH 0/5] crypto: LEA block cipher implementation
Date: Mon, 4 Dec 2023 17:09:18 +0900
Message-ID: <002101da2689$2ddd8c00$8998a400$@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQH2yIhSQ+2fjzZfex7vEe+2daDNgLBfgS4g

We accidentally omitted the version in the title. This patch should have been titled as follows.
"[PATCH v5 0/5] crypto: LEA block cipher implementation"
