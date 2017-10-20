From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6 17/38] crypto: ccp: Implement SEV_PDH_GEN ioctl command
Date: Thu, 19 Oct 2017 21:33:52 -0500
Message-ID: <20171020023413.122280-18-brijesh.singh@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: kvm@vger.kernel.org
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020023413.122280-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The SEV_PDH_GEN command is used to re-generate the Platform
Diffie-Hellman (PDH) key. The command is defined in SEV spec section
5.6.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1d7212da25a5..d9771d104eea 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -239,6 +239,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_PEK_GEN:
 		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
 		break;
+	case SEV_PDH_GEN:
+		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
