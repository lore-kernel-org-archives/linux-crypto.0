Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="LvJk6adi"
Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5514FB;
	Sat, 25 Nov 2023 23:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1700982458; bh=nh8oXDZrE99UzNjND6tyL+laThRQuP8L/2BY7Nqu3gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvJk6adiXzOAuGLVp1zj41ax5A8ekbs13jXJcAjlX6o/GKXA++Fe5YGxilO28uwyV
	 19foL57tcy6C9h9uIzBOmLcHHtgdUyH1hEdPPgFMSYvlkto+ZfOVyfri87kMKRTYgw
	 GRMjcDk9E0fa3peeIwnqReHbkiC+lUCPYqGcHvWk=
Received: from pek-lxu-l1.wrs.com ([111.198.228.56])
	by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
	id 1E40CC1A; Sun, 26 Nov 2023 15:07:36 +0800
X-QQ-mid: xmsmtpt1700982456t1x138g0f
Message-ID: <tencent_97BC6EC36EF24C91A7E7C6DFD2C106688906@qq.com>
X-QQ-XMAILINFO: OKkKo7I1HxIeI0hB7WvsBqfntZuCEqsWCguVkXJ0exKDD9z5GDKAXVeRtxt30r
	 8Q25KbtGSORdOE5B3u3kCMf7HseurkQtlwTO4rWJg5NIycAzBD7vw4sB+jp4qUCOGr2JK7uTKITw
	 CpXbA0TSAjAAmmm65nXw9FBzm2/uZipgsLZQpPc+j5mu/35J6L4v6zhSXUx3JLMfVD3Z8SdEC6pM
	 U7+uP+kJbrhCGLjhdsZfIcqMuI/dOnCigcfTm9TjeXrcpL+sjHUIRYLNugN9ccpqGyZXYQBp5J4d
	 j4AkNWeQJvdOnz61E3almNNmmWsKLhvCV8yIPKEV/9eSamc8vNHagE41nou1IJ0eBwud+2R9Csh+
	 1w6bPMZ/Xgjqn+/6EH+BIbDrqPOax+aTcV6bWcpMH0CqXcq3vR7A8XAFIvU7v/SX3NnGKFofYcYT
	 B8EQzNpHzeB7/7STUaqW1WwIEIvw8gNsrknbyzvaY7XYgLpQUuDMZcDgvFFqCiewuYRQUQX7MF8f
	 wbFDv3dmL2U1Gk5snZZuxBDTzcDeRKbDNXYZTjLJMf+GbVHFto6DHgMqiRpRU+8KIE6nZVO6VTF7
	 7RIFCN0fIucfjQ/YIhpQowpbiWZHDrQxY/vup0WRjvIsYLFt+He38JJR9UOWpPRS2j0eBW50C8FB
	 ImpnegBFlMbtZeBvo2AE4x9ihOF1IADYbvYAHB726V66mwTwSEaEdiK6xy3Hitt9crTjPZxJrA74
	 2KA+VST3FcU1otwbNVsxrGpEtOW4KNTw4N9Jsk9qyw9HZkpUUi6QX99jdIt6C5f7b+5cGlWfZW8w
	 erFpbzF+lOFpZD0GjlK1ly6wHwv0K3KDUpAX9M2jLaNQupJswcmIKSZM/Jfb3kzRk6rINNZQubna
	 XJB508pqK4G2Qjt39xf1lBcH6pPkV0rIBHF0N4F4bTjbIdi/ff9Y2Qa2NW8ylCb6H2Uy9tfsnl
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+c52ab18308964d248092@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] hwrng: core - fix task hung in hwrng_fillfn
Date: Sun, 26 Nov 2023 15:07:36 +0800
X-OQ-MSGID: <20231126070735.462195-2-eadavis@qq.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <0000000000003d77e6060af9f233@google.com>
References: <0000000000003d77e6060af9f233@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: ***

[Syz repo]
INFO: task hwrng:749 blocked for more than 143 seconds.
      Not tainted 6.7.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:hwrng           state:D stack:29040 pid:749   tgid:749   ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5376 [inline]
 __schedule+0xedb/0x5af0 kernel/sched/core.c:6688
 __schedule_loop kernel/sched/core.c:6763 [inline]
 schedule+0xe9/0x270 kernel/sched/core.c:6778
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6835
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0x5b9/0x9d0 kernel/locking/mutex.c:747
 hwrng_fillfn+0x145/0x430 drivers/char/hw_random/core.c:504
 kthread+0x2c6/0x3a0 kernel/kthread.c:388
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242
 </TASK>

...

RIP: 0010:rep_movs_alternative+0x57/0x70 arch/x86/lib/copy_user_64.S:80
Code: 00 66 90 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 df 83 f9 08 73 e8 eb c9 eb 01 c3 48 89 c8 48 c1 e9 03 83 e0 07 <f3> 48 a5 89 c1 85 c9 75 b3 c3 48 8d 0c c8 eb ac 66 0f 1f 84 00 00
RSP: 0018:ffffc90004427bb0 EFLAGS: 00050246
RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000008
RDX: ffffed1028a4ab48 RSI: ffff888145255a00 RDI: 0000000020019980
RBP: 0000000020019980 R08: 0000000000000000 R09: ffffed1028a4ab47
R10: ffff888145255a3f R11: 0000000000000001 R12: ffff888145255a00
R13: 00000000200199c0 R14: 0000000000000000 R15: dffffc0000000000
 copy_user_generic arch/x86/include/asm/uaccess_64.h:112 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:133 [inline]
 _copy_to_user lib/usercopy.c:41 [inline]
 _copy_to_user+0xa8/0xb0 lib/usercopy.c:34
 copy_to_user include/linux/uaccess.h:191 [inline]
 rng_dev_read+0x184/0x580 drivers/char/hw_random/core.c:255
 do_loop_readv_writev fs/read_write.c:755 [inline]
 do_loop_readv_writev fs/read_write.c:743 [inline]
 do_iter_read+0x567/0x830 fs/read_write.c:797
 vfs_readv+0x12d/0x1a0 fs/read_write.c:915
 do_preadv fs/read_write.c:1007 [inline]
 __do_sys_preadv fs/read_write.c:1057 [inline]
 __se_sys_preadv fs/read_write.c:1052 [inline]
 __x64_sys_preadv+0x228/0x300 fs/read_write.c:1052
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

[Analysis]
The lock reading_mutex in rng_dev_read() has been occupied for too long, 
causing the thread callback function hwrng_fillfn() to wait for a timeout.

[Fix]
Move code that does not require this lock protection out of the critical area.

Reported-and-tested-by: syzbot+c52ab18308964d248092@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 drivers/char/hw_random/core.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 420f155d251f..7323ddc958ce 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -225,17 +225,18 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out;
 		}
 
-		if (mutex_lock_interruptible(&reading_mutex)) {
-			err = -ERESTARTSYS;
-			goto out_put;
-		}
 		if (!data_avail) {
+			if (mutex_lock_interruptible(&reading_mutex)) {
+				err = -ERESTARTSYS;
+				goto out_put;
+			}
 			bytes_read = rng_get_data(rng, rng_buffer,
 				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
+			mutex_unlock(&reading_mutex);
 			if (bytes_read < 0) {
 				err = bytes_read;
-				goto out_unlock_reading;
+				goto out_put;
 			}
 			data_avail = bytes_read;
 		}
@@ -243,7 +244,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 		if (!data_avail) {
 			if (filp->f_flags & O_NONBLOCK) {
 				err = -EAGAIN;
-				goto out_unlock_reading;
+				goto out_put;
 			}
 		} else {
 			len = data_avail;
@@ -255,14 +256,13 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			if (copy_to_user(buf + ret, rng_buffer + data_avail,
 								len)) {
 				err = -EFAULT;
-				goto out_unlock_reading;
+				goto out_put;
 			}
 
 			size -= len;
 			ret += len;
 		}
 
-		mutex_unlock(&reading_mutex);
 		put_rng(rng);
 
 		if (need_resched())
@@ -276,8 +276,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 out:
 	return ret ? : err;
 
-out_unlock_reading:
-	mutex_unlock(&reading_mutex);
 out_put:
 	put_rng(rng);
 	goto out;
@@ -501,7 +499,10 @@ static int hwrng_fillfn(void *unused)
 		rng = get_current_rng();
 		if (IS_ERR(rng) || !rng)
 			break;
-		mutex_lock(&reading_mutex);
+		if (mutex_lock_interruptible(&reading_mutex)) {
+			put_rng(rng);
+			return -ERESTARTSYS;
+		}
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
 		if (current_quality != rng->quality)
-- 
2.25.1

