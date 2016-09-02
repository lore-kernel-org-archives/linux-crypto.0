From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: dm-crypt: flush crypt_queue on suspend? on REQ_FLUSH?
Date: Fri, 2 Sep 2016 15:13:47 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609021430390.5413@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org
To: dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:56607 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751765AbcIBWNt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 18:13:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

We have a KVM => dm-crypt => dm-thin stack in and a snapshot may have 
partially completed queued IO out-of-order.  EXT4 is giving errors like 
this after mounting a snapshot, but only on files recently modified near 
the snapshot time.  This might imply out-of-order writes since, 
presumably, the ext4 journal would handle deletions in journal order and 
snapshots should be safe at any time:

	kernel: EXT4-fs error (device dm-2): ext4_lookup:1441: inode #1196093: comm rsync: deleted inode referenced: 1188710 

Notably, the ext4 error did not present prior to the snapshot.  We have 
rsync logs from hours before that didn't report this message, but all 
later rsyncs do.

Perhaps related, or perhaps not, crypt_map() notes the following:
	1914          * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
	1915          * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
	1916          * - for REQ_DISCARD caller must use flush if IO ordering matters

However, crypt_map returns DM_MAPIO_SUBMITTED after calling 
kcryptd_queue_crypt(io) which processes asynchronously on 
cc->crypto_queue.  In crypt_ctr(), alloc_workqueue sets max_active to 
num_online_cpus() unless 'same_cpu_crypt' is set in the dm table (mine is 
not), so if I understand correctly, completion could happen out of order 
with CPUs >1.

Does the dm stack know that the bio (dm_crypt_io) hasn't been completed 
even though it was put on a work queue?  If so, I would like to understand 
that dm bio-tracking mechanism, so please point me at documentation or 
code.

If not, then does crypt_map() need a workqueue_flush(cc->crypto_queue) on 
REQ_FLUSH?  

I'm new to the dm-crypt code, so please educate me if I'm missing 
something here.

Thank you for your help!

--
Eric Wheeler
